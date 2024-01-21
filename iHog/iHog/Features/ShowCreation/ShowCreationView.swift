//
//  ShowCreationView.swift
//  iHog
//
//  Created by Jay on 1/21/24.
//

import SwiftUI

struct ShowCreationView: View {
  @Environment(\.dismiss) var dismiss
  @State private var showName = ""

  var body: some View {
    NavigationStack {
      Form {
        TextField("ShowCreateView.showName", text: $showName)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("ShowCreateView.save") {
            print("Save")
          }
        }
        ToolbarItem(placement: .topBarLeading) {
          Button("ShowCreateView.cancel") {
            dismiss()
          }
          .tint(.red)
        }
      }
      .navigationTitle(Text("ShowCreationView.viewTitle"))
    }
  }
}

#Preview {
  Text("Hello")
    .sheet(
      isPresented: .constant(true),
      content: {
        ShowCreationView()
      }
    )
}
