//
//  AllOptionsPaywallView.swift
//  iHog
//
//  Created by Jay Wilson on 8/12/22.
//

import SwiftUI
import RevenueCat

struct CurrentPaywallView: View {
    @EnvironmentObject var user: UserState

    @State private var selectedPackage = 1

    var issue: Int? = nil
    var packages: [Package] {
        return user.offerings?.current?.availablePackages ?? []
    }
    var showTitle: Bool {
        return issue != nil
    }
    
    var analyticsSource: PaywallSource

    var body: some View {
        VStack {
            PaidFeaturesView(issue: issue)
            Spacer()
            ForEach(0..<packages.count, id: \.self){ packageInt in
                PurchaseButtonView(isSelected: (packageInt == selectedPackage), package: packages[packageInt], analyticsSource: analyticsSource)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedPackage = packageInt
                    }
            }.padding(.bottom)
            Spacer()
            HStack {
                Text("[Terms of Service](\(Links.terms))")
                Spacer()
                Button {
                    Task {
                        await restore()
                    }                        } label: {
                        Text("Restore purchases")
                    }
                Spacer()
                Text("[Privacy policy](\(Links.privacy))")
            }
            .font(.footnote)
            .foregroundColor(.accentColor)
            .padding(.horizontal)
            .padding(.bottom)
        }.navigationTitle("Become a Pro")
            .navigationBarTitleDisplayMode(.inline)
    }

    func restore() async {
        do {
            user.customerInfo = try await Purchases.shared.restorePurchases()
        } catch {
            Analytics.shared.logError(with: error, for: .purchases)
        }
    }
}

struct CurrentPaywallView_Previews: PreviewProvider {
    @StateObject static private var user = UserState()
    
    static var previews: some View {
        CurrentPaywallView(analyticsSource: .preview)
            .environmentObject(user)
            .task {
                do {
                    user.offerings = try await Purchases.shared.offerings()
                } catch {
                    Analytics.shared.logError(with: error, for: .purchases)
                }
            }
    }
}
