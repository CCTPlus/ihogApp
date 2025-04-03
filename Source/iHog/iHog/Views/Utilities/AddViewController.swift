//
//  AddViewController.swift
//  iHog
//
//  Created by Jay Wilson on 9/13/22.
//

import SwiftUI

struct AddViewController: View {
  var viewToAdd: AddView

  var body: some View {
    switch viewToAdd {
      case .shows:
        NewShowView()
    }
  }
}

struct AddViewController_Previews: PreviewProvider {
  static var previews: some View {
    AddViewController(viewToAdd: .shows)
  }
}
