//
//  OnboardingPaywallView.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import SwiftUI
import RevenueCat

struct OnboardingPaywall: View {
    @AppStorage(Settings.showOnboarding.rawValue) var completedOnboarding: Bool!
    @EnvironmentObject var user: UserState
    @Environment(\.dismiss) var dismiss

    var packages: [Package] {
        return user.offerings?[RCConstants.Offerings.year.rawValue]?.availablePackages ?? []
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Button("Close") {
                    dismiss()
                }.foregroundColor(.red)
            }.padding(.bottom)
            HStack(alignment: .center) {
                Image(systemName: SFSymbol._wandandstars.name)
                    .foregroundColor(.accentColor)
                Text("Become a PRO-grammer and unlock these features")
                    .font(.headline)
                Image(systemName: SFSymbol._wandandstars.name)
                    .foregroundColor(.accentColor)
            }
            Spacer()
            PaidFeaturesView()
                .multilineTextAlignment(.leading)
            Spacer()
            VStack {
                if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil {
                    Button("Start your free trial") {
                        print("Purchase should be made")
                    }.buttonStyle(.borderedProminent)
                    Text("then $3.99 per year")
                        .font(.footnote)
                } else {
                    ForEach(packages) { package in
                        Button("Start your \(package.terms(for: package))") {
                            Purchases.shared.purchase(package: package) { (_, _, error, _) in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    dismiss()
                                }
                            }
                        }.buttonStyle(.borderedProminent)
                        Text(setPrice(package))
                            .font(.footnote)
                    }
                }
            }.padding(.bottom, 60)

            Button("Not right now") {
                dismiss()
            }
        }.padding()
    }

    func setPrice( _ package: Package) -> String {
        let price = package.localizedPriceString
        let duration = package.storeProduct.subscriptionPeriod!.durationTitle
        return "then \(price) per \(duration)"
    }
}

struct OnboardingPaywall_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPaywall()
            .environmentObject(UserState())
    }
}
