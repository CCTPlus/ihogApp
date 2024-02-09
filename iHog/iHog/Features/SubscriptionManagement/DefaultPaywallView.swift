//
//  DefaultPaywallView.swift
//  iHog
//
//  Created by Jay on 1/25/24.
//

import RevenueCat
import SwiftUI

struct DefaultPaywallView: View {
  @Environment(\.dismiss) var dismiss

  var runningOnPhone: Bool {
    UIDevice.current.userInterfaceIdiom == .phone
  }

  var body: some View {
    List {
      Section {
        HStack(alignment: .top) {
          Text("iHog Pro")
            .font(.largeTitle)
            .bold()
          Spacer()
          Button {
            dismiss()
          } label: {
            Text("Cancel")
          }
          .tint(.red)
        }
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
      VStack {
        MonthAndYearOptionView(offeringID: "default")
      }
      .buttonStyle(.plain)
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
