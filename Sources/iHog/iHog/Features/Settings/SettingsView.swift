//
//  Settings.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//

import AppRouter
import CoreData
import RevenueCat
import StoreKit
import SwiftUI

struct SettingsView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  @EnvironmentObject var user: UserState
  @EnvironmentObject var osc: OSCHelper
  @EnvironmentObject var toast: ToastNotification

  @State private var notificationTask: Task<Void, Never>? = nil

  @State private var isAddingShow: Bool = false
  @State var issueSubmitted: Bool? = false
  @State private var isOSCExpanded = true
  @State private var showExportLog = false
  @State private var logURL: URL? = nil
  @State private var showUserProfile = false

  @State private var router = AppRouter()

  /// MARK: Navigation
  let paywalls: [Paywall] = [.currentPaywall]

  var networkMonitor = NetworkMonitor.shared

  private var foundProducts: [Package] {
    return user.offerings?[RCConstants.Offerings.year.name]?.availablePackages ?? []
  }

  var showRepository: ShowRepository? = nil

  var body: some View {
    NavigationSplitView {
      List(selection: $router.routerDestination) {
        // MARK: Hardware views
        Section {
          NavigationLink(value: RouterDestination.playback) {
            HStack {
              ListIcon(color: .teal, symbol: ._slidervertical3)
              Text("Playback")
              Spacer()
            }
          }
          NavigationLink(value: RouterDestination.programmer) {
            HStack {
              ListIcon(color: .purple, symbol: ._cooktop)
              Text("Programmer")
            }
          }
        }
        // MARK: Shows
        Section {
          HStack {
            ListIcon(color: .gray, symbol: ._folderbadgeplus)
            Text("My Shows")
            Spacer()
            Button("\(Image(symbol: ._pluscircle))") {
              addShow()
            }
          }
          ShowSelectionView()
            .environment(router)
            .environment(\.modelContext, modelContext)
        }
        // MARK: Settings
        Section {
          NavigationLink(value: RouterDestination.osc) {
            HStack {
              ListIcon(color: .green, symbol: ._wifi)
              Text("Open Sound Control Settings")
            }
          }
          NavigationLink(value: RouterDestination.programmerSettings) {
            HStack {
              ListIcon(color: .purple, symbol: ._cooktopfill)
              Text("Programmer Settings")
            }
          }
          NavigationLink(value: RouterDestination.showSettings) {
            HStack {
              ListIcon(color: .gray, symbol: ._folderbadgegearshape)
              Text("Show Settings")
            }
          }
        }
        // MARK: Feedback
        Section {
          NavigationLink(value: RouterDestination.appFeedback) {
            Label {
              Text("Send feedback")
            } icon: {
              ListIcon(color: .accentColor, symbol: ._paperplane)
            }
          }
          .disabled(!networkMonitor.isReachable)
          ShareLink(item: Links.appStore) {
            Label {
              Text("Share iHog")
            } icon: {
              ListIcon(color: .orange, symbol: ._squareandarrowup)
            }
          }
          .disabled(!networkMonitor.isReachable)
          Button {
            requestReview()
          } label: {
            Label {
              Text("Rate iHog")
            } icon: {
              ListIcon(color: .orange, symbol: ._star)
            }
          }
          .disabled(!networkMonitor.isReachable)
        } header: {
          if !networkMonitor.isReachable {
            Text("Connect to the internet")
          }
        }
        // MARK: Support
        Section {
          Button {
            let mailTo = "mailto:support@cctplus.dev?subject=iHog%20help%20needed?"
            UIApplication.shared.open(URL(string: mailTo)!)
          } label: {
            Label {
              Text("Email Jay")
            } icon: {
              ListIcon(color: .accentColor, symbol: ._paperplane)
            }
          }
          Button {
            do {
              logURL = nil
              logURL = try HogLogger().getLogs()
            } catch {
              Analytics.shared.logError(with: error, for: .default, level: .warning)
            }
          } label: {
            Label {
              Text("Collect Logs")
            } icon: {
              ListIcon(color: .red, symbol: ._listbullet)
            }
          }
          if logURL != nil {
            ShareLink(item: logURL!, message: Text("Logs from iHog"))
          }
        } header: {
          Text("Need help?")
        }

        VStack {
          Text("App version: \(AppInfo.version) (\(AppInfo.build))")
          Text("Made with ☕ in 🌲🌲🌲")
        }
        .frame(maxWidth: .infinity)
        .font(.footnote)
        .foregroundColor(.secondaryLabel)
        .listRowBackground(Color.clear)

      }
      .listStyle(.insetGrouped)
      .navigationTitle(AppInfo.name)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            router.openSheet(.userProfile)
            Analytics.shared.logEvent(with: .userProfileTapped)
          } label: {
            Image(symbol: ._person)
          }
        }
      }
      .sheet(item: $router.selectedSheet) { sheet in
        switch sheet {
          case .userProfile:
            NavigationStack {
              UserProfileView(
                showRepository: ShowSwiftDataRepository(modelContainer: modelContext.container),
                showObjectRepository: ShowObjectSwiftDataRepository(
                  modelContainer: modelContext.container
                )
              )
              .presentationDetents([.large])
              .presentationDragIndicator(.visible)
            }
          case .newShow:
            NavigationStack {
              NewShowView()
                .environment(\.modelContext, modelContext)
            }
          case .paywall:
            NavigationStack {
              CurrentPaywallView(issue: 0, analyticsSource: .newShowView)
                .environmentObject(user)
            }
        }
      }
    } detail: {
      switch router.routerDestination {
        case .show(let showID):
          ShowNavigation(
            chosenShow: ChosenShow(
              showID: showID,
              showObjectRepository: ShowObjectSwiftDataRepository(
                modelContainer: modelContext.container
              ),
              showRepository: ShowSwiftDataRepository(modelContainer: modelContext.container)
            )
          )
        case .osc:
          OSCSettings()
        case .programmer:
          FPProgrammer()
        case .playback:
          FPPlayback()
        case .programmerSettings:
          ProgrammerSettings()
        case .showSettings:
          ShowSetting()
        case .appFeedback:
          UserFeedbackView()
        case .none:
          OSCSettings()
      }
    }
    .task {
      notificationTask = Task {
        await listenForShowCreated()
      }
    }
    .onDisappear {
      networkMonitor.stopMonitoring()
      notificationTask?.cancel()
    }
  }

  func listenForShowCreated() async {
    await Task.detached {
      for await notification in NotificationCenter.default.notifications(named: .didSaveShow) {
        guard let show = notification.object as? Show else {
          HogLogger
            .log(category: .show)
            .error("🔔 Saved show notification could not find Show object")
          continue
        }
        await MainActor.run {
          HogLogger.log(category: .show).info("🔔 Saved show notification fired")
          router.changeShow(to: show.id)
        }
      }
    }
    .value
  }

  func addShow() {
    if user.isPro {
      user.setNavigation(to: .addView(.shows))
    } else {
      Task {
        let showRepository =
          self.showRepository
          ?? ShowSwiftDataRepository(
            modelContainer: modelContext.container
          )
        let showsCount: Int = (try? await showRepository.getCountOfShows()) ?? 0
        if showsCount >= 1 {
          router.openSheet(.paywall)
        } else {
          router.openSheet(.newShow)
        }
      }
    }
  }

  func requestReview() {
    guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      print("UNABLE TO GET CURRENT SCENE")
      return
    }
    SKStoreReviewController.requestReview(in: currentScene)
  }

}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environmentObject(UserState())
      .environmentObject(OSCHelper(ip: "120.000.000.012", inputPort: 1234, outputPort: 1235))
  }
}
