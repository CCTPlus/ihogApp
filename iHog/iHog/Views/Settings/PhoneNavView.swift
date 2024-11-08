//
//  PhoneNavView.swift
//  iHog
//
//  Created by Jay Wilson on 4/19/22.
//

import SwiftUI
import RevenueCat

struct PhoneNavView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject var osc: OSCHelper
    @EnvironmentObject var user: UserState
    @EnvironmentObject var toast: ToastNotification
    
    // Gets shows
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ShowEntity.dateLastModified, ascending: true)],
        animation: .default)
    private var shows: FetchedResults<ShowEntity>

    @State var selectedSetting: SettingsNav? = SettingsNav.device
    @State private var isAddingShow: Bool = false
    @State var issueSubmitted: Bool? = false
    @State private var isOSCExpanded = false
    @State private var showPaywall = false
    private var foundProducts: [Package] {
        return user.offerings?[RCConstants.Offerings.year.name]?.availablePackages ?? []
    }

    var body: some View {
        List {
            Section {
                DisclosureGroup("OSC Settings", isExpanded: $isOSCExpanded) {
                    OSCSettings()
                        .padding(.horizontal)
                    NavigationLink("OSC Log") {
                        OSCLogView()
                    }.padding(.horizontal)
                }
                DisclosureGroup("Programmer Settings") {
                    ProgrammerSettings()
                        .padding(.horizontal)
                }
                DisclosureGroup("Show Settings") {
                    ShowSetting()
                        .padding(.horizontal)
                }
            } header: {
                Text("Settings")
            }.headerProminence(.increased)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            if !user.isPro {
                Section {
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
                    }.frame(maxWidth: .infinity)
                } footer: {
                    HStack {
                        Spacer()
                        Button("Learn more") {
                            showPaywall.toggle()
                        }.font(.footnote)
                            .padding()
                    }
                }.listRowBackground(Color.clear)
                    .sheet(isPresented: $showPaywall) {
                        CurrentPaywallView(analyticsSource: .learnMore)
                    }
            }
            AllShowsView()
            Section {
                NavigationLink("Programmer") { FPProgrammer() }
                NavigationLink("Playback") { FPPlayback() }
            } header: {
                Text("Front Panel")
            }.headerProminence(.increased)
                .listRowBackground(Color(UIColor.systemGroupedBackground))
            
            About(selectedSetting: $selectedSetting, issueSubmitted: $issueSubmitted)
                .listRowBackground(Color(UIColor.systemGroupedBackground))
                .listRowSeparator(.hidden)
        }
    }

    func setPrice( _ package: Package) -> String {
        let price = package.localizedPriceString
        let duration = package.storeProduct.subscriptionPeriod!.durationTitle
        return "then \(price) per \(duration)"
    }
}

struct PhoneNavViews_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNavView()
            .environmentObject(UserState())
            .environmentObject(OSCHelper(ip: "192.888.888.888",
                                         inputPort: 2002,
                                         outputPort: 2002))
            .environmentObject(ToastNotification())
    }
}
