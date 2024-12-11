//
//  ExperimentalFeatureView.swift
//  iHog
//
//  Created by Jay Wilson on 12/9/24.
//

import SwiftData
import SwiftUI

@available(iOS 17, *)
struct ExperimentalFeatureView: View {
  @Environment(\.modelContext) var context

  @Query(sort: \UserCode.dateCreated) var codes: [UserCode]

  @AppStorage(FeatureFlagKey.swiftdata.rawValue) var featureSwiftData = FeatureFlagKey.swiftdata
    .isAvailable

  var body: some View {
    Section {
      if codes.contains(where: { $0.code == "IH241208SBU" })
        || codes.contains(where: { $0.code == "IH241208ID" })
      {
        Toggle(FeatureFlagKey.swiftdata.listLabel, isOn: $featureSwiftData)
      } else {
        Text("No experimental features available")
      }
    } header: {
      Text("Experimental Features")
    } footer: {
      Text("Enabling these features may cause data loss.")
    }
    .onChange(of: featureSwiftData) { newValue in
      Analytics.shared.logFeatureFlagToggle(flag: .swiftdata, value: newValue)
    }
  }
}

#Preview {
  if #available(iOS 17, *) {
    ExperimentalFeatureView()
  } else {
    // Fallback on earlier versions
  }
}
