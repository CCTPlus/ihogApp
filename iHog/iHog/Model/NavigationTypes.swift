//
//  NavigationTypes.swift
//  iHog
//
//  Created by Jay Wilson on 9/13/22.
//

import Foundation

enum Paywall: Hashable {
    case currentPaywall
    case onboarding
    case yearly
}

enum AddView: Hashable {
    case shows
}
enum Routes: Hashable {
    case paywall(Paywall)
    case addView(AddView)
    case shows(ShowEntity)
    case programmerSettings
    case showSettings
    case osc
    case programmer
    case playback
    case appFeedback
}
