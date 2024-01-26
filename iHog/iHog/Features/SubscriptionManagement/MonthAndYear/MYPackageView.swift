//
//  MYPackageView.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import RevenueCat
import SwiftUI

struct MYPackageView: View {
  @State private var introOfferStatus: IntroEligibilityStatus = .noIntroOfferExists

  var isSelected: Bool
  var package: Package

  var body: some View {
    VStack {
      if introOfferStatus == .eligible {
        Text("1 week free trial")
          .font(.subheadline)
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
          .background(.secondary)
      }
      Text(package.packageType == .monthly ? "1 month" : "12 months")
        .font(.headline)
        .padding(.top, 8)
      Text(package.localizedPriceString)
        .font(.title)
        .bold()
        .padding(.bottom, 8)
        .padding(.top, 4)
      VStack {
        Text(package.storeProduct.localizedPricePerMonth ?? "0.0")
        Text("per month")
          .frame(maxWidth: .infinity)
        Text("billed \(package.packageType == .annual ? "annually" : "monthly")")
      }
      .font(.footnote)
      .padding(.vertical, 8)
      .background(.secondary)
    }
    .background(.bar)
    .background(isSelected ? Color.accentColor : .clear)
    .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
    .task {
      await viewSetup()
    }
  }
  func viewSetup() async {
    let statuses = await Purchases.shared.checkTrialOrIntroDiscountEligibility(packages: [package])
    introOfferStatus = statuses[package]?.status ?? .unknown
  }
}

//#Preview {
//  var package: Package = Package(identifier: "iHog", packageType: .annual, storeProduct: StoreProduct(sk1Product: SK1Product()), offeringIdentifier: "current")
//
//  var test: Int {
//    Purchases.shared.getOfferings { offerings, error in
//      guard error != nil else { return }
//      package = (offerings?.current?.availablePackages.first)!
//    }
//    return 0
//  }
//
//  return MYPackageView(isSelected: .constant(true), package: package)
//}
