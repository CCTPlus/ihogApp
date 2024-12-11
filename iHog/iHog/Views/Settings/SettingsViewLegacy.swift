//
//  Settings.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//

import CoreData
import RevenueCat
import StoreKit
import SwiftUI

/// iOS 16 only Settings View. Bug fixes might be here, but not a lot.
struct SettingsViewLegacy: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  @EnvironmentObject var user: UserState
  @EnvironmentObject var osc: OSCHelper
  @EnvironmentObject var toast: ToastNotification

  // Gets shows
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \CDShowEntity.dateLastModified, ascending: true)],
    animation: .default
  )
  private var shows: FetchedResults<CDShowEntity>

  @State private var isAddingShow: Bool = false
  @State var issueSubmitted: Bool? = false
  @State private var isOSCExpanded = true
  @State private var showExportLog = false
  @State private var logURL: URL? = nil
  @State private var showUserProfile = false

  /// MARK: Navigation
  let paywalls: [Paywall] = [.currentPaywall]

  var networkMonitor = NetworkMonitor.shared

  private var foundProducts: [Package] {
    return user.offerings?[RCConstants.Offerings.year.name]?.availablePackages ?? []
  }

  var body: some View {
    NavigationSplitView {
      List(selection: $user.navigation) {
        // MARK: Hardware views
        Section {
          NavigationLink(value: Routes.playback) {
            HStack {
              ListIcon(color: .teal, symbol: ._slidervertical3)
              Text("Playback")
              Spacer()
            }
          }
          NavigationLink(value: Routes.programmer) {
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
          ForEach(shows) { show in
            NavigationLink(value: Routes.shows(show)) {
              HStack {
                ZStack {
                  Color.gray
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                  Image(systemName: show.icon ?? SFSymbol._folder.name)
                    .foregroundColor(.white)
                }
                Text(show.name ?? "Name not found")
              }
            }
          }
          .onDelete { indexSet in
            self.delete(at: indexSet)
          }
        }
        // MARK: Settings
        Section {
          NavigationLink(value: Routes.osc) {
            HStack {
              ListIcon(color: .green, symbol: ._wifi)
              Text("Open Sound Control Settings")
            }
          }
          NavigationLink(value: Routes.programmerSettings) {
            HStack {
              ListIcon(color: .purple, symbol: ._cooktopfill)
              Text("Programmer Settings")
            }
          }
          NavigationLink(value: Routes.showSettings) {
            HStack {
              ListIcon(color: .gray, symbol: ._folderbadgegearshape)
              Text("Show Settings")
            }
          }
        }
        // MARK: Feedback
        Section {
          NavigationLink(value: Routes.appFeedback) {
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
            showUserProfile.toggle()
          } label: {
            Image(symbol: ._person)
          }
          .sheet(isPresented: $showUserProfile) {
            UserProfileView()
              .environment(\.managedObjectContext, viewContext)
              .presentationDetents([.large])
              .presentationDragIndicator(.visible)
          }
        }
      }
    } detail: {
      switch user.navigation {
        case let .paywall(paywall):
          PaywallView(analtycsSource: .settings, paywall: paywall)
        case let .addView(addView):
          AddViewController(viewToAdd: addView)
        case let .shows(show):
          if let showID = show.id {
            ShowNavigation(
              selectedShow: show,
              chosenShow: ChosenShow(
                showID: showID.uuidString,
                persistence: PersistenceController.shared
              )
            )
          } else {
            Text("Something is wrong. Please send an email to support@cctplus.dev")
          }
        case .osc:
          OSCSettings()
            .navigationTitle("OSC Settings")
            .navigationBarTitleDisplayMode(.inline)
        case .programmerSettings:
          ProgrammerSettings()
        case .showSettings:
          ShowSetting()
        case .programmer:
          FPProgrammer()
        case .playback:
          FPPlayback()
        case .appFeedback:
          UserFeedbackView()
        default:
          Text("Choose from left")
      }
    }
    .task {
      networkMonitor.startMonitoring()
    }
    .onDisappear {
      networkMonitor.stopMonitoring()
    }
  }

  func delete(at offsets: IndexSet) {
    let indexOfShow: Int = offsets.first ?? 0

    let showID: NSUUID = shows[indexOfShow].id! as NSUUID

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(
      entityName: "ShowEntity"
    )
    fetchRequest.predicate = NSPredicate(format: "id == %@", showID as CVarArg)
    fetchRequest.fetchLimit = 1
    do {
      let test = try viewContext.fetch(fetchRequest)
      let showToDelete = test[0] as! NSManagedObject
      viewContext.delete(showToDelete)
      try viewContext.save()
    } catch {
      Analytics.shared.logError(with: error, for: .coreData, level: .critical)
    }
  }

  func addShow() {
    if user.isPro {
      user.setNavigation(to: .addView(.shows))
    } else {
      if shows.count >= 1 {
        user.setNavigation(to: .paywall(.currentPaywall))
      } else {
        user.setNavigation(to: .addView(.shows))
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

struct SettingsViewLegacy_Previews: PreviewProvider {
  static var previews: some View {
    SettingsViewLegacy()
      .environmentObject(UserState())
      .environmentObject(OSCHelper(ip: "120.000.000.012", inputPort: 1234, outputPort: 1235))
  }
}
