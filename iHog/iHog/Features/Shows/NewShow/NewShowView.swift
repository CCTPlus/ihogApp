//
//  NewShowView.swift
//  iHog
//
//  Created by Jay Wilson on 1/24/25.
//

import Models
import SwiftUI

struct NewShowView: View {
  @Environment(UserStateManager.self) var userState
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) var modelContext

  @State private var selectedIcon: SFSymbol = ._folder
  @State private var showName: String = "New Show"
  @State private var showIconChoice: Bool = false
  @State private var showPaywall: Bool = false

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
          if userState.isPro {
            showIconChoice.toggle()
          } else {
            showPaywall = true
          }
        } label: {
          Image(symbol: selectedIcon)
        }

        TextField("Show name", text: $showName)
      }
      .padding(.leading)
      Spacer()
      if showIconChoice && userState.isPro {
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
      } else if showPaywall {
        CurrentPaywallView(issue: 4, analyticsSource: .addIconView)
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
    let newShow = ShowEntity(
      dateCreated: .now,
      dateLastModified: .now,
      icon: selectedIcon.name,
      id: UUID(),
      name: showName,
      note: nil,
      objects: [],
      notes: []
    )
    modelContext.insert(newShow)
    do {
      try modelContext.save()
      dismiss()
    } catch {
      HogLogger.log(category: .swiftData)
        .error("🚨 \(#file) \(#function) cannot save show \(error, privacy: .public)")
    }
  }
}

#Preview {
  NewShowView()
    .environment(UserStateManager(isPro: true))
    .modelContainer(SwiftDataManager.previewContainer)
}
