//
//  PurchaseButtonView.swift
//  iHog
//
//  Created by Jay Wilson on 8/23/22.
//

import RevenueCat
import SwiftUI

struct PurchaseButtonView: View {
  @EnvironmentObject var user: UserState
  @Environment(\.dismiss) var dismiss
  var isSelected: Bool

  let samplePrice = "$0.99"
  let sampleUnit = "month"
  let sampleFreeTrial = "2 weeks free"

  var package: Package? = nil

  var price: String {
    package?.localizedPriceString ?? samplePrice
  }
  var units: String {
    if package?.storeProduct.subscriptionPeriod != nil {
      return "per \(package?.storeProduct.subscriptionPeriod?.durationTitle ?? sampleUnit)"
    } else {
      return "one time purchase"
    }
  }
  var freeTrial: String {
    package?.terms(for: package!) ?? ""
  }
  var backgroundColor: Color {
    return isSelected ? .accentColor : .gray
  }
  var icon: SFSymbol {
    return isSelected ? ._checkmarkcirclefill : ._circle
  }
  var buttonText: String {
    if package?.hasFreeTrial == true {
      return "Start my \(freeTrial)"
    } else {
      return "Start now"
    }
  }

  var analyticsSource: PaywallSource

  var body: some View {
    VStack {
      HStack(alignment: .top) {
        HStack(alignment: .top) {
          VStack(alignment: .leading) {
            if package?.isSubscription == true {
              Text(
                package?.storeProduct.subscriptionPeriod?.durationAdverb.localizedCapitalized ?? ""
              )
              .font(.headline)
              if package?.hasFreeTrial == true {
                Text(
                  "First \(package?.discountTerms ?? freeTrial) are free,\nthen \(price) \(units)"
                )
                .lineLimit(nil)
                .padding(.top, HALF_PADDING * 0.25)
              } else {
                Text("\(price) \(units)")
                  .padding(.top, HALF_PADDING * 0.25)
              }
            } else {
              Text("Lifetime")
                .font(.headline)
              Text(price)
              Text("One time purchase")
                .font(.footnote)
            }
          }
        }
        Spacer()
        if package?.hasFreeTrial == true {
          Text("Free trial")
            .font(.subheadline)
            .padding(HALF_PADDING)
            .background(RoundedRectangle(cornerRadius: BASE_CORNER_RADIUS).fill(Color.orange))
        }
      }
      if isSelected {
        Button(buttonText) {
          purchase()
          Analytics.shared.logEvent(
            with: .subscribeButtonTapped,
            parameters: [.paywallSource: analyticsSource.analyticsLabel]
          )
        }
        .buttonStyle(.borderedProminent)
      }
    }
    .padding(BASE_PADDING)
    .background(
      RoundedRectangle(cornerRadius: BASE_CORNER_RADIUS).fill(backgroundColor.opacity(0.2))
    )
    .background(
      RoundedRectangle(cornerRadius: BASE_CORNER_RADIUS)
        .stroke(style: StrokeStyle(lineWidth: 2)).foregroundColor(backgroundColor)
    )
  }

  func purchase() {
    Purchases.shared.purchase(package: package!) { (storeTransaction, customerInfo, error, _) in
      if let error = error {
        Analytics.shared.logError(with: error, for: .purchases, level: .critical)
        dismiss()
      }

      if let storeTransaction = storeTransaction {
        if let transaction = storeTransaction.sk2Transaction {
          Analytics.shared.logPurchase(transacion: transaction)
        }
      }

      if customerInfo?.entitlements[RCConstants.Entitlements.pro.name]?.isActive == true {
        user.unlockPro()
        dismiss()
      }
    }
  }
}

struct PurchaseButtonView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      PurchaseButtonView(isSelected: true, analyticsSource: .preview)
        .padding()
      PurchaseButtonView(isSelected: false, analyticsSource: .preview)
        .padding()
    }
  }
}
