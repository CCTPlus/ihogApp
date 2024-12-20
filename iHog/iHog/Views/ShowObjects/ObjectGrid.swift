//
//  ObjectGrid.swift
//  iHog
//
//  Created by Jay Wilson on 9/21/20.
//

import SwiftUI

struct ObjectGrid: View {
  var size: String
  var buttonsAcross: Int
  var objects: [ShowObject]
  @ObservedObject var show: ChosenShow

  var body: some View {
    ScrollView(.vertical) {
      LazyVGrid(columns: getColumns(), spacing: 0.0) {
        ForEach(objects, id: \.self) { obj in
          ShowObjectView(show: show, obj: obj, size: size)
        }
      }
    }
  }

  func getColumns() -> [GridItem] {
    var columns: [GridItem] = []
    for _ in 0..<buttonsAcross {
      columns.append(
        GridItem(.flexible(minimum: 100, maximum: 400))
      )
    }
    return columns
  }
}

//struct ObjectGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        ObjectGrid(
//            size: "small",
//            buttonsAcross: 5,
//            objects: testShowObjects)
//    }
//}
