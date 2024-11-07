//
//  OnboardingView.swift
//  iHog
//
//  Created by Jay Wilson on 2/14/22.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(Settings.showOnboarding.rawValue) var showOnboarding: Bool = true
    @EnvironmentObject var osc: OSCHelper

    @State var currentStep = 1
    @Binding var setting: SettingsNav

    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String

    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text(appName!)
                    .font(.largeTitle)
                OBProgressView(currentStep: currentStep)
            }
            switch currentStep {
            case 1:
                IntroToiHogView(currentStep: $currentStep)
                    .opacity(currentStep == 1 ? 1 : 0)
                    .animation(.easeInOut(duration: 2), value: currentStep)
            case 2:
                OBConsoleSettings(currentStep: $currentStep)
                    .environmentObject(osc)
                    .opacity(currentStep == 2 ? 1 : 0)
                    .animation(.easeInOut(duration: 2), value: currentStep)
            case 3:
                OBIPAddress(setting: $setting, currentStep: $currentStep)
                    .environmentObject(osc)
                    .opacity(currentStep == 3 ? 1 : 0)
                    .animation(.easeInOut(duration: 2), value: currentStep)
            default:
                Text("Onboarding is complete")
            }
            Button("Skip") {
                print("goes to device settings")
                showOnboarding = false
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    @State static var settings = SettingsNav.device

    static var previews: some View {
        OnboardingView(setting: $settings)
    }
}
