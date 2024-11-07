//
//  iHogApp.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//  Supporters:
//  DustinD_Miller
//  panjakesnbacon
//  MikaelaCaron - 2022-09-21
//

import SwiftUI
import RevenueCat
import StoreKit
import CoffeeToast

class ToastNotification: ObservableObject {
    @Published var isShown = false
    var color = Color.clear
    var text = ""

    let ms = 1000000

    func animateIn(text: String, color: Color) {
        self.text = text
        self.color = color

        DispatchQueue.main.async {
            self.isShown = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isShown = false
        }
    }
}

@main
struct iHogApp: App {
    @AppStorage(Settings.timesLaunched.rawValue) var timesLaunched: Int = 0
    @AppStorage(Settings.showOnboarding.rawValue) var showOnboarding: Bool = true

    @Environment(\.requestReview) var requestReview

    @StateObject var osc = OSCHelper(ip: "192.168.0.101", inputPort: 9009, outputPort: 9009)
    @StateObject var user = UserState()

    let persistenceController = PersistenceController.shared
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(
            with: Configuration.Builder(withAPIKey: RCConstants.apiKey)
                .with(usesStoreKit2IfAvailable: true)
                .build())
    }

    @StateObject private var toastNotification = ToastNotification()
    @State private var settings = SettingsNav.device

    var body: some Scene {
        WindowGroup {
            Toast(toastNotification.text, backgroundColor: toastNotification.color, isShown: $toastNotification.isShown) {
                if showOnboarding {
                    OnboardingView(setting: $settings)
                        .environmentObject(osc)
                        .environmentObject(user)
                } else {
                    SettingsView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(osc)
                        .environmentObject(user)
                        .environmentObject(toastNotification)
                }
            }.task {
                timesLaunched += 1
                if timesLaunched >= 5 {
                    requestReview()
                }
                do {
                    user.customerInfo = try await Purchases.shared.restorePurchases()
                } catch {
                    print("⚠️ \(error.localizedDescription)")
                }
                do {
                    user.offerings = try await Purchases.shared.offerings()
                    for await customerInfo in Purchases.shared.customerInfoStream {
                        #if DEBUG
                        print(":::: \(customerInfo.activeSubscriptions)")
                        #endif
                        user.customerInfo = customerInfo
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
