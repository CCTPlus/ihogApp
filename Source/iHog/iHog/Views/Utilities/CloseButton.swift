//
//  CloseButton.swift
//  iHog
//
//  Created by Jay Wilson on 10/25/21.
//

import SwiftUI

struct CloseButton: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    HStack {
      Spacer()
      Button(action: {
        dismiss()
      }) {
        Text("Close")
          .foregroundColor(.red)
          .padding(.all)
      }
    }
  }
}

//struct CloseButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CloseButton()
//    }
//}
