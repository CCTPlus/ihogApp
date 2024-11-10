//
//  NewShowView.swift
//  iHog
//
//  Created by Jay Wilson on 10/16/20.
//

import CoreData
import SwiftUI

struct NewShowView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var user: UserState

  @State private var selectedIcon: SFSymbol = ._folder
  @State private var showName: String = "New Show"
  @State private var presentIconChoice = false

  var showIconChoice: Bool {
    return presentIconChoice && user.isPro
  }

  let gridItems = [
    GridItem(.flexible(), spacing: 10, alignment: .center),
    GridItem(.flexible(), spacing: 10, alignment: .center),
    GridItem(.flexible(), spacing: 10, alignment: .center),
    GridItem(.flexible(), spacing: 10, alignment: .center),
  ]

  var body: some View {
    VStack {
      HStack {
        Button {
          presentIconChoice.toggle()
        } label: {
          Image(symbol: selectedIcon)
            .font(.title)
        }

        TextField("Show Name", text: $showName)
          .multilineTextAlignment(.center)
          .foregroundColor(.blue)
          .textFieldStyle(.roundedBorder)
          .padding()
      }
      .padding(.leading)
      Spacer()
      if presentIconChoice {
        if showIconChoice {
          ScrollView {
            LazyVGrid(columns: gridItems) {
              ForEach(SFSymbol.ALL_ICONS, id: \.self) { icon in
                Button {
                  self.selectedIcon = icon
                } label: {
                  Image(symbol: icon)
                    .font(.title)
                }
                .tint(.gray)
                .padding(.all, HALF_PADDING)

              }
            }
          }
          .padding(.bottom)
        } else {
          CurrentPaywallView(issue: 4, analyticsSource: .addIconView)
        }
      }
    }
    .navigationTitle("\(showName)")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigation) {
        Button("Add") {
          addShow()
        }
      }
    }
  }

  private func addShow() {
    withAnimation {
      let newShow = CDShowEntity(context: viewContext)
      newShow.dateCreated = Date()
      newShow.dateLastModified = Date()
      newShow.id = UUID()
      newShow.name = showName
      newShow.note = ""
      newShow.icon = selectedIcon.name

      do {
        try viewContext.save()
        user.resetNavigation()
      } catch {
        Analytics.shared.logError(with: error, for: .coreData)
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}

struct NewShowView_Previews: PreviewProvider {
  static var previews: some View {
    NewShowView()
      .environmentObject(UserState())
  }
}
