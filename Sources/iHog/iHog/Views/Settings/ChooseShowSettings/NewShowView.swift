//
//  NewShowView.swift
//  iHog
//
//  Created by Jay Wilson on 10/16/20.
//

import CoreData
import SwiftUI

struct NewShowView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) var context

  @EnvironmentObject var user: UserState

  @State private var selectedIcon: SFSymbol = ._folder
  @State private var showName: String = "New Show"
  @State private var presentIconChoice = false

  var showRepository: ShowRepository? = nil

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
      ToolbarItem(placement: .topBarTrailing) {
        Button("Add") {
          addShow()
        }
      }
    }
  }

  private func addShow() {
    let repository = showRepository ?? ShowSwiftDataRepository(modelContainer: context.container)

    Task {
      do {
        let name = showName
        let icon = selectedIcon.name
        let createdShow = try await repository.createShow(name: name, icon: icon)
        HogLogger.log(category: .show).info("Created show \(createdShow.name)")
        await MainActor.run {
          self.user.resetNavigation()
          dismiss()
        }
      } catch {
        HogLogger.log(category: .show).error("Cannot create show \(error)")
      }
    }
  }
}

struct NewShowView_Previews: PreviewProvider {
  static var previews: some View {
    NewShowView(showRepository: ShowMockRespository.previewWithShows)
      .environmentObject(UserState())
  }
}
