//
//  UserCodeView.swift
//  iHog
//
//  Created by Jay Wilson on 12/7/24.
//

import SwiftData
import SwiftUI

@available(iOS 17, *)
struct UserCodeView: View {
  @Environment(\.modelContext) var context
  @Query(sort: \UserCode.dateCreated) var codes: [UserCode]

  @State private var analyticsCode: String = ""
  @State private var showAlert = false

  let sbUserCode = "IH241208SBU"
  let internalTestingCode = "IH241208ID"

  var body: some View {
    Group {
      ForEach(codes) { code in
        HStack {
          Text(code.viewCode)
          Spacer()
          Text(code.viewDate.formatted(date: .abbreviated, time: .omitted))
        }
      }
      Button("Add code") {
        showAlert = true
      }
      .alert("Enter Analytics Code You Received", isPresented: $showAlert) {
        TextField("Analytics Code", text: $analyticsCode)
        Button("OK", action: submit)
      }
      .task {
        addTestflightCode()
      }
    }
  }
}

#Preview {
  if #available(iOS 17, *) {
    UserCodeView()
  } else {
    // Fallback on earlier versions
    Text("Not available before iOS 17")
  }
}

@available(iOS 17, *)
extension UserCodeView {
  func submit() {
    // Only want to add a code if the user doesn't have it
    if !codes.contains(where: { $0.code == analyticsCode }) {
      let newCode = UserCode(dateCreated: .now, code: analyticsCode)
      context.insert(newCode)
      try? context.save()
      HogLogger.log().info("Added new code: \(analyticsCode)")
    } else {
      HogLogger.log().info("User already has code: \(analyticsCode)")
    }
    showAlert = false
  }

  func addTestflightCode() {
    let isSandboxed = AppInfo.isSandboxed
    if isSandboxed && !codes.contains(where: { $0.code == sbUserCode }) {
      let betaTesterCode = UserCode(dateCreated: .now, code: sbUserCode)
      context.insert(betaTesterCode)
      #if DEBUG
        // Adds internal testing code to unlock options
        if !codes.contains(where: { $0.code == internalTestingCode }) {
          let internalTestingCode = UserCode(dateCreated: .now, code: internalTestingCode)
          context.insert(internalTestingCode)
        }
      #endif
      do {
        try context.save()
      } catch {
        HogLogger.log().error("🚨 Error saving code: \(error)")
      }
    } else {
      HogLogger.log()
        .info("User either is not sandboxed or already has the betaTester code so not adding it")
    }
    addCodesToAnalytics()
  }

  func addCodesToAnalytics() {
    let analyticsCodes: [String] = codes.compactMap({ $0.code })
    Analytics.shared.logAnalyticsCodes(analyticsCodes)
  }
}
