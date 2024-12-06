//
//  AppEntryView.swift
//  Features
//
//  Created by Jay Wilson on 11/25/24.
//

import DataManager
import DesignSystem
import Router
import Settings
import SwiftUI

public struct AppEntryView: View {
  @State private var router = Router()

  public init() {}

  public var body: some View {
    Group {
      if #available(iOS 18.0, *) {
        tabView
      } else {
        legacyTabView
      }
    }
    .environment(router)
    .sheet(item: $router.presentedSheet) { sheetDestination in
      switch sheetDestination {
        case .newShow:
          Text("New show")
      }
    }
  }
}

#Preview {
  AppEntryView()
    .modelContainer(ShowEntity.preview)
    .environment(Router())
}

extension AppEntryView {
  /// iOS 18 and newer tabviews
  @available(iOS 18.0, *)
  @ViewBuilder var tabView: some View {
    // Fallback on earlier versions
    TabView(selection: $router.selectedTab) {
      Tab(
        AppTab.programming.label,
        systemImage: AppTab.programming.icon,
        value: AppTab.programming
      ) {
        AppTab.programming.view
      }
      Tab(
        AppTab.playback.label,
        systemImage: AppTab.playback.icon,
        value: AppTab.playback
      ) {
        AppTab.playback.view

      }
      Tab(
        AppTab.puntPage.label,
        systemImage: AppTab.puntPage.icon,
        value: AppTab.puntPage
      ) {
        AppTab.puntPage.view

      }
      Tab(
        AppTab.settings.label,
        systemImage: AppTab.settings.icon,
        value: AppTab.settings
      ) {
        AppTab.settings.view
      }
    }
  }

  /// iOS 17 tab views
  @ViewBuilder var legacyTabView: some View {
    TabView(selection: $router.selectedTab) {
      ForEach(AppTab.allCases) { appTab in
        // Fallback on earlier versions
        appTab.view
          .tabItem {
            Label(appTab.label, systemImage: appTab.icon)
          }
          .tag(appTab)
      }
    }
  }
}

extension AppTab {
  @MainActor
  @ViewBuilder var view: some View {
    switch self {
      case .programming:
        Text(analyticsValue.uppercased())
      case .playback:
        Text(analyticsValue.uppercased())
      case .puntPage:
        Text(analyticsValue.uppercased())
      case .settings:
        SettingsView()
    }
  }
}
