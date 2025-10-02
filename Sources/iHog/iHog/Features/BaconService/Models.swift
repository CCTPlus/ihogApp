//
//  Models.swift
//  iHog
//
//  Created by Jay Wilson on 10/1/25.
//

import Foundation

struct BaconSuccessResponse: Codable, Sendable {
  let success: Bool
  let message: String
  let entitlement: String
  let userId: String
  let grantedAt: Date
  let expiresAt: Date

  init(message: String, entitlement: String, userId: String, grantedAt: Date, expiresAt: Date) {
    self.success = true
    self.message = message
    self.entitlement = entitlement
    self.userId = userId
    self.grantedAt = grantedAt
    self.expiresAt = expiresAt
  }
}

struct BaconErrorResponse: Codable, Error {
  let success: Bool
  let error: String
  let code: BaconErrorCode
  let details: String?

  init(error: String, code: BaconErrorCode, details: String? = nil) {
    self.success = false
    self.error = error
    self.code = code
    self.details = details
  }
}

enum BaconErrorCode: String, CaseIterable, Codable {
  case missingUserIdHeader = "MISSING_USER_ID_HEADER"
  case invalidEntitlement = "INVALID_ENTITLEMENT"
  case emptyUserId = "EMPTY_USER_ID"
  case customerNotFound = "CUSTOMER_NOT_FOUND"
  case entitlementNotFound = "ENTITLEMENT_NOT_FOUND"
  case networkError = "NETWORK_ERROR"
  case serverError = "SERVER_ERROR"
  case invalidApiKey = "INVALID_API_KEY"
  case invalidResponse = "INVALID_RESPONSE"
  case invalidDate = "INVALID_DATE"
}
