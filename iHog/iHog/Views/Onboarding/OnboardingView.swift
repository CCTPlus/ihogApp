//
//  OnboardingView.swift
//  iHog
//
//  Created by Jay Wilson on 2/14/22.
//

import SwiftUI

struct OnboardingView: View {
  @AppStorage(AppStorageKey.showOnboarding.rawValue) var showOnboarding: Bool = true
  @EnvironmentObject var osc: OSCHelper

  @State var currentStep = 1
  @Binding var setting: SettingsNav

  let appVersion = AppInfo.version
  let appBuild = AppInfo.build
  let appName = AppInfo.name

  var body: some View {
    VStack(spacing: 40) {
      VStack {
        Text(appName)
          .font(.largeTitle)
        OBProgressView(currentStep: currentStep)
      }
      switch currentStep {
        case 1:
          IntroToiHogView(currentStep: $currentStep)
            .opacity(currentStep == 1 ? 1 : 0)
            .animation(.easeInOut(duration: 2), value: currentStep)
            .onAppear {
              analyticsHookForViewingOnboardingStep()
            }
        case 2:
          OBConsoleSettings(currentStep: $currentStep)
            .environmentObject(osc)
            .opacity(currentStep == 2 ? 1 : 0)
            .animation(.easeInOut(duration: 2), value: currentStep)
            .onAppear {
              analyticsHookForViewingOnboardingStep()
            }
        case 3:
          OBIPAddress(setting: $setting, currentStep: $currentStep)
            .environmentObject(osc)
            .opacity(currentStep == 3 ? 1 : 0)
            .animation(.easeInOut(duration: 2), value: currentStep)
            .onAppear {
              analyticsHookForViewingOnboardingStep()
            }
        default:
          Text("Onboarding is complete")
      }
      Button("Skip") {
        Analytics.shared.logEvent(
          with: .onboardingSkipTapped,
          parameters: [.onboardingStep: currentStep]
        )
        showOnboarding = false
      }
    }
  }

  func analyticsHookForViewingOnboardingStep() {
    Analytics.shared.logEvent(
      with: .onboardingStepViewed,
      parameters: [.onboardingStep: currentStep]
    )
  }
}

struct OnboardingView_Previews: PreviewProvider {
  @State static var settings = SettingsNav.device

  static var previews: some View {
    OnboardingView(setting: $settings)
  }
}
