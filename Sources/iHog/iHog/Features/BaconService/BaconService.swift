//
//  BaconService.swift
//  iHog
//
//  Created by Jay Wilson on 10/1/25.
//

import Foundation

struct BaconService {
  func grantLifetimeEntitlement(for userID: String) async throws -> BaconSuccessResponse {
    guard var url = URL(string: AppInfo.api) else { throw URLError(.badURL) }
    url = url.appendingPathComponent("bacon")
    url = url.appending(path: "grant-entitlement")
    url = url.appending(queryItems: [.init(name: "entitlement", value: "early-adopter")])

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(userID, forHTTPHeaderField: "x-user-id")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw URLError(.badServerResponse)
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    if (200...299).contains(httpResponse.statusCode) {
      return try decoder.decode(BaconSuccessResponse.self, from: data)
    } else {
      let errorResponse = try decoder.decode(BaconErrorResponse.self, from: data)
      throw errorResponse
    }
  }
}
