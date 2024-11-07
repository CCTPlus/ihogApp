//
//  MonthAndYearOptionView.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import OSLog
import RevenueCat
import SwiftUI

struct MonthAndYearOptionView: View {
  @State private var offering: Offering? = nil
  @State private var selectedPackage: Package? = nil
  @State private var annualPricePerYear: NSDecimalNumber = 0.0
  @State private var monthPricePerYear: NSDecimalNumber = 0.0

  var offeringID: String

  init(offeringID: String) {
    self.offeringID = offeringID
  }

  var body: some View {
    VStack {
      Text("Ready to go pro?")
        .font(.largeTitle)
        .bold()
        .padding()
      HStack(alignment: .bottom, spacing: 16.0) {
        if let offering {
            ForEach(offering.availablePackages) { package in
                Button {
                    selectedPackage = package
                } label: {
                    PurchasePackageView(isSelected: selectedPackage == package, package: package)
                }
                .overlay {
                  RoundedRectangle(cornerRadius: 12, style: .circular)
                    .stroke(selectedPackage == package ? Color.accentColor : .clear, lineWidth: 4.0)
                }

            }
        }
      }
      Button {
        Task {
          do {
            let purchased = try await Purchases.shared.purchase(package: selectedPackage!)
            Logger.iap.debug("\(purchased.customerInfo.activeSubscriptions)")
          } catch {
            Logger.iap.error("\(error)")
          }
        }
      } label: {
        Text("Upgrade to pro")
          .frame(maxWidth: .infinity)
          .font(.title)
          .bold()
      }
      .buttonStyle(.borderedProminent)
      .padding(.vertical, 12)
      Button {
        Task {
          do {
            _ = try await Purchases.shared.restorePurchases()
          } catch {
            Logger.iap.error("\(error)")
          }
        }
      } label: {
        Text("Restore purchases")
              .font(.footnote)
              .fontDesign(.monospaced)
      }
      .buttonStyle(.borderless)
    }
    .padding(.bottom, 12)
    .task {
      do {
        try await getOffering()
      } catch {
        Logger.iap.error("\(error)")
      }
    }
  }

  private func getOffering() async throws {
    let offerings = try await Purchases.shared.offerings()
    self.offering = offerings.offering(identifier: offeringID)
    Logger.iap.debug("\(offering?.identifier ?? "NO OFFERING FOUND")")
    selectedPackage = offering?.annual
  }
}

#Preview {
    List {
        VStack {
            MonthAndYearOptionView(offeringID: "default")
        }
        .buttonStyle(.plain)
    }
}
