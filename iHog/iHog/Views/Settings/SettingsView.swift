//
//  Settings.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//

import SwiftUI
import CoreData
import StoreKit
import RevenueCat

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var user: UserState
    @EnvironmentObject var osc: OSCHelper
    @EnvironmentObject var toast: ToastNotification
    
    // Gets shows
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ShowEntity.dateLastModified, ascending: true)],
        animation: .default)
    private var shows: FetchedResults<ShowEntity>
    
    @State private var isAddingShow: Bool = false
    @State var issueSubmitted: Bool? = false
    @State private var isOSCExpanded = true
    
    /// MARK: Navigation
    let paywalls: [Paywall] = [.currentPaywall]
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    var networkMonitor = NetworkMonitor.shared
    
    private var foundProducts: [Package] {
        return user.offerings?[RCConstants.Offerings.year.name]?.availablePackages ?? []
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $user.navigation) {
                if !user.isPro {
                    VStack(alignment: .center) {
                        HStack {
                            Image(symbol: ._wandandstars)
                            Text("Be a PRO-grammer")
                            Image(symbol: ._wandandstars)
                        }
                        Text("Unlock unlimited shows and more")
                            .lineLimit(nil)
                        ForEach(foundProducts, id: \.self) { package in
                            Button("Start your \(package.terms(for: package))") {
                                Purchases.shared.purchase(package: package) { (_, customerInfo, error, _) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }
                                    if customerInfo?.entitlements[RCConstants.Entitlements.pro.name]?.isActive == true {
                                        user.unlockPro()
                                    }
                                }
                            }.buttonStyle(.borderedProminent)
                            Text(setPrice(package))
                                .font(.footnote)
                        }
                        NavigationLink("Learn more", value: Routes.paywall(.currentPaywall))
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                } else {
                    HStack {
                        ListIcon(color: .accentColor, symbol: ._wandandrays)
                        Text("You're a pro!")
                    }
                }
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
                    }.onDelete { indexSet in
                        self.delete(at: indexSet)
                    }
                }
                
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
                
                Section {
                    NavigationLink(value: Routes.appFeedback) {
                        Label {
                            Text("Send feedback")
                        } icon: {
                            ListIcon(color: .accentColor, symbol: ._paperplane)
                        }
                    }.disabled(!networkMonitor.isReachable)
                    ShareLink(item: Links.appStore) {
                        Label {
                            Text("Share iHog")
                        } icon: {
                            ListIcon(color: .orange, symbol: ._squareandarrowup)
                        }
                    }.disabled(!networkMonitor.isReachable)
                    Button {
                        requestReview()
                    } label: {
                        Label {
                            Text("Rate iHog")
                        } icon: {
                            ListIcon(color: .orange, symbol: ._star)
                        }
                    }.disabled(!networkMonitor.isReachable)
                } header: {
                    if !networkMonitor.isReachable {
                        Text("Connect to the internet")
                    }
                }
                
                VStack {
                    Text("App version: \(appVersion ?? "UNRELEASED") (\(appBuild ?? "UNRELEASED"))")
                    Text("Made with ♡ in Austin")
                }.frame(maxWidth: .infinity)
                    .font(.footnote)
                    .foregroundColor(.secondaryLabel)
                    .listRowBackground(Color.clear)
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("iHog")
        } detail: {
            switch user.navigation {
            case let .paywall(paywall):
                PaywallView(paywall: paywall)
            case let .addView(addView):
                AddViewController(viewToAdd: addView)
            case let .shows(show):
                ShowNavigation(selectedShow: show)
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
        }.task {
            networkMonitor.startMonitoring()
        }.onDisappear {
            networkMonitor.stopMonitoring()
        }
    }
    
    func setPrice( _ package: Package) -> String {
        let price = package.localizedPriceString
        let duration = package.storeProduct.subscriptionPeriod!.durationTitle
        return "then \(price) per \(duration)"
    }
    
    
    func delete(at offsets: IndexSet) {
        let indexOfShow: Int = offsets.first ?? 0
        
        let showID: NSUUID = shows[indexOfShow].id! as NSUUID
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ShowEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", showID as CVarArg)
        fetchRequest.fetchLimit = 1
        do{
            let test = try viewContext.fetch(fetchRequest)
            let showToDelete = test[0] as! NSManagedObject
            viewContext.delete(showToDelete)
            try viewContext.save()
        } catch{
            print(error)
        }
    }
    
    func addShow(){
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserState())
            .environmentObject(OSCHelper(ip: "120.000.000.012", inputPort: 1234, outputPort: 1235))
    }
}
