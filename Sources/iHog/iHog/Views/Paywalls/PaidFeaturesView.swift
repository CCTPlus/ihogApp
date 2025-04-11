//
//  PaidFeaturesView.swift
//  iHog
//
//  Created by Jay Wilson on 8/11/22.
//

import SwiftUI

struct Feature: Identifiable {
  let id: Int
  let name: String
  let symbol: String
  var freeAlternative: String? = nil
  let color: Color
}

struct PaidFeaturesView: View {
  var issue: Int? = nil

  let features = [
    Feature(
      id: 0,
      name: "Unlimited shows",
      symbol: SFSymbol._folderbadgeplus.name,
      freeAlternative: "1 show",
      color: .orange
    ),
    Feature(
      id: 4,
      name: "Custom icons for shows",
      symbol: SFSymbol._questionmarkfolder.name,
      freeAlternative: "1 show",
      color: .teal
    ),
    Feature(
      id: 1,
      name: "Punt Page",
      symbol: SFSymbol._sliderhorizontalbelowsquareandsquarefilled.name,
      color: .pink
    ),
    Feature(
      id: 3,
      name: "Continuous bug fixes and feature additions",
      symbol: SFSymbol._clockarrow2circlepath.name,
      color: .purple
    ),
    Feature(
      id: 2,
      name: "Support the longevity of iHog",
      symbol: SFSymbol._cupandsaucer.name,
      color: .gray
    ),
  ]
  var body: some View {
    ScrollView {
      ForEach(features) { feature in
        HStack(alignment: .center) {
          Image(systemName: feature.symbol)
            .foregroundColor(feature.color)
          HStack {
            Text(feature.name)
              .font(.body)
            if (issue == feature.id) == true {
              Spacer()
              Text("Unlock with subscription")
                .font(.custom("San Fransisco", size: 10, relativeTo: .footnote))
                .padding(BASE_PADDING)
                .background {
                  RoundedRectangle(cornerRadius: DOUBLE_CORNER_RADIUS)
                    .fill(.regularMaterial)
                }
            }
          }
          Spacer()
        }
        .padding(.vertical, BASE_PADDING)
      }
    }
    .padding()
  }
}

struct PaidFeaturesView_Previews: PreviewProvider {
  static var previews: some View {
    PaidFeaturesView(issue: 1)
  }
}
