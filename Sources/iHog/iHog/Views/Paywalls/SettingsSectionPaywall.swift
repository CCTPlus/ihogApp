//
//  SettingsSectionPaywall.swift
//  iHog
//
//  Created by Jay Wilson on 11/8/24.
//

import RevenueCat
import StoreKit
import SwiftUI

struct SettingsSectionPaywall: View {
  @EnvironmentObject var user: UserState

  private var foundProducts: [Package] {
    return user.offerings?[RCConstants.Offerings.year.name]?.availablePackages ?? []
  }

  var body: some View {
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
            Analytics.shared.logEvent(
              with: .subscribeButtonTapped,
              parameters: [.paywallSource: PaywallSource.settings]
            )
          }
        }
        .buttonStyle(.borderedProminent)
        Text(setPrice(package))
          .font(.footnote)
      }
      NavigationLink("Learn more", value: Routes.paywall(.currentPaywall))
        .font(.footnote)
        .foregroundColor(.blue)
    }

  }
}

#Preview {
  SettingsSectionPaywall()
    .environmentObject(UserState())
}

extension SettingsSectionPaywall {
  func setPrice(_ package: Package) -> String {
    let price = package.localizedPriceString
    let duration = package.storeProduct.subscriptionPeriod!.durationTitle
    return "then \(price) per \(duration)"
  }

}
