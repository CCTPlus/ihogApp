//
//  PaywallView.swift
//  iHog
//
//  Created by Jay Wilson on 9/13/22.
//

import SwiftUI

struct PaywallView: View {
    var analtycsSource: PaywallSource
    var paywall: Paywall
    
    var body: some View {
        switch paywall {
        case .onboarding:
            OnboardingView(setting: .constant(.device))
        default:
                CurrentPaywallView(analyticsSource: analtycsSource)
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView(analtycsSource: .preview, paywall: .currentPaywall)
    }
}
