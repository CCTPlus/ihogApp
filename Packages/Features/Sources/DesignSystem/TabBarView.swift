//
//  TabBarView.swift
//  iHog
//
//  Created by Jay Wilson on 11/24/24.
//

import Router
import SwiftUI

/// Custom tab bar
struct TabBarView: View {
  @Environment(\.colorScheme) var colorScheme
  @Environment(Router.self) var router

  @State private var isExpanded = true

  var gradientStartColor: Color {
    switch colorScheme {
      case .dark:
        return .cyan
      default:
        return .blue
    }
  }

  var gradientStopColor: Color {
    switch colorScheme {
      case .dark:
        return .black
      default:
        return .white
    }
  }

  var iconColor: Color {
    switch colorScheme {
      case .dark:
        return .white
      default:
        return .black
    }
  }

  var body: some View {
    HStack {
      Spacer()
      HStack(spacing: .Spacing.large) {
        Button {
          withAnimation {
            isExpanded.toggle()
          }
        } label: {
          Image(systemName: isExpanded ? "chevron.right" : "chevron.left")
            .bold()
            .imageScale(.large)
            .foregroundStyle(iconColor)
            .padding(.trailing, isExpanded ? 16 : 0)
        }

        if isExpanded {
          ForEach(AppTab.allCases) { appTab in
            Button {
              withAnimation {
                if router.selectedTab == appTab {
                  router.popToRoot()
                }
                router.selectedTab = appTab
              }
            } label: {
              Image(systemName: appTab.icon)
                .symbolRenderingMode(.palette)
                .symbolVariant(router.selectedTab == appTab ? .fill : .none)
                .symbolEffect(.pulse, options: .repeat(2), value: appTab)
                .imageScale(.large)
                .foregroundStyle(iconColor)
                .padding(4)
            }
          }
        }
      }
      .frame(height: 30)
      .frame(minWidth: 30)
      .padding(.all)
      .background(Material.thin)
      .background(
        LinearGradient(
          colors: [gradientStartColor, gradientStopColor],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: 24, style: .circular))
      .shadow(color: gradientStartColor, radius: 8, x: 0, y: 4)
    }
  }
}

#Preview("Color variants") {
  VStack(spacing: .Spacing.large * 4) {
    HStack {
      Spacer()
      TabBarView()
        .environment(Router())
        .colorScheme(.dark)
      Spacer()
    }
    .padding(24)
    .background(Color.black)
    HStack {
      Spacer()
      TabBarView()
        .environment(Router())
        .colorScheme(.light)
      Spacer()
    }
    .padding(24)
  }
}
