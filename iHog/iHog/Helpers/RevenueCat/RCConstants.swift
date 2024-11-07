//
//  RCConstants.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import Foundation

struct RCConstants {
    static let apiKey = "appl_iuNkLloJrdhvmSrVYSoZPrfJcOp"

    enum Entitlements: String {
        case pro
        case puntPage = "punt-page"

        var name: String { return rawValue }
    }

    enum Offerings: String {
        case puntPage = "punt-page-default"
        case tipping = "tipping-default"
        case normal = "default"
        case year = "year"

        var name: String { return rawValue }
    }

    func getConvertedToSubscriptionDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.date(from: "2022/09/17")
    }
}
