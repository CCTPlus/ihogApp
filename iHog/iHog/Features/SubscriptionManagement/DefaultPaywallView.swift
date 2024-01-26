//
//  DefaultPaywallView.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import RevenueCat
import SwiftUI

struct DefaultPaywallView: View {
  @State private var showSheet = true
  @State private var sheetHeight: CGFloat = .zero

  var body: some View {
    List {
      Section {
        Text("iHog Pro")
          .font(.largeTitle)
          .bold()
      }
      .listRowInsets(.none)
      .listRowBackground(Color.clear)
      .listSectionSeparator(.hidden)
      Section {
        ForEach(Feature.allCases) { feature in
          featureRow(string: feature.viewName)
        }
        Label("Support an indie developer", systemImage: "laptopcomputer.and.ipad")
      }

      Section {
        VStack(alignment: .center, spacing: 12) {
          Text("Any questions?")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity)
          Text("Reach out to Jay and ask!")
          Link(
            destination: URL(string: "mailto:support@cctplus.dev?subject=iHog Pro Question")!,
            label: {
              Label("Email Jay", systemImage: "envelope")
            }
          )
        }
      }
      .listRowBackground(Color.clear)
      .listRowSeparator(.hidden)
    }
    .sheet(isPresented: $showSheet) {
      MonthAndYearOptionView(offeringID: "default")
        .heightChangePreference(completion: { height in
          sheetHeight = height
        })
        .padding(.horizontal)
        .presentationDetents([.height(sheetHeight)])
        .presentationBackgroundInteraction(.enabled(upThrough: .height(sheetHeight)))
        .presentationCornerRadius(24)
        .interactiveDismissDisabled()
    }
  }

  @ViewBuilder
  func featureRow(string: String) -> some View {
    Label(string, systemImage: "chevron.right.circle")
      .padding(.bottom, 2)
  }
}

#Preview {
  DefaultPaywallView()
}
