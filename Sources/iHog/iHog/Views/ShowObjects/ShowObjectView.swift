//
//  ShowObjectView.swift
//  iHog
//
//  Created by Jay Wilson on 9/21/20.
//

import CoreData
import SwiftUI

struct ShowObjectView: View {
  @EnvironmentObject var osc: OSCHelper

  @State private var showEditWindow: Bool = false
  @ObservedObject var show: ChosenShow

  var obj: ShowObject
  var size: String
  var body: some View {
    Button(action: { sendOSC() }) {
      VStack(alignment: .leading) {
        HStack {
          Text(obj.getShortType())
          Spacer()
          Text("\(obj.getObjNumber())")
        }
        Spacer()
        Text(obj.getName())
          .font(.headline)

      }
      .frame(width: getSize(), height: getSize(), alignment: .leading)
      .padding()
      .background(obj.isOutlined ? Color.clear : OBJ_COLORS[obj.getColor()])
      .cornerRadius(BASE_CORNER_RADIUS)
      .overlay(
        RoundedRectangle(cornerRadius: (DOUBLE_CORNER_RADIUS))
          .stroke(OBJ_COLORS[obj.getColor()], lineWidth: BASE_LINE_WIDTH)
      )
      .padding()
      .sheet(isPresented: $showEditWindow) {
        EditObjectView(show: show, obj: obj)
      }
    }
    .foregroundColor(.primary)
    .contextMenu {
      if obj.objType == .scene || obj.objType == .list {
        Button(action: { sendReleaseOSC() }) {
          Image(systemName: "stop.fill")
          Text("Release")
        }
      }
      Button(action: { self.showEditWindow.toggle() }) {
        Image(systemName: "pencil")
        Text("Edit")
      }
      Button(action: deleteObject) {
        Image(systemName: "trash")
        Text("Delete")
      }
    }
  }

  func getSize() -> CGFloat {
    switch size {
      case "small":
        return SMALL_OBJ_BUTTON_SIZE
      case "medium":
        return MEDIUM_OBJ_BUTTON_SIZE
      case "large":
        return LARGE_OBJ_BUTTON_SIZE
      case "extra large":
        return XL_OBJ_BUTTON_SIZE
      default:
        return MEDIUM_OBJ_BUTTON_SIZE
    }
  }

  func getColor() -> Color {
    switch obj.objColor {
      case "red":
        return .red
      case "yellow":
        return .yellow
      default:
        return .gray
    }
  }

  func deleteObject() {
    Task {
      let objectID = obj.id
      let objectType = obj.objType
      do {
        try await show.deleteObject(by: objectID, objType: objectType)
      } catch {
        Analytics.shared.logError(with: error, for: .coreData, level: .critical)
      }
    }
  }

  func sendOSC() {
    let objNum = obj.getObjNumber()
    switch obj.objType {
      case .group, .intensity, .position, .color, .beam, .effect:
        osc.selectProgrammingObject(objNumber: objNum, objType: obj.objType)
      case .list:
        osc.goList(objNumber: objNum)
      case .scene:
        osc.goScene(objNumber: objNum)
      default:
        print("Need a proper object type")
    }
  }

  func sendReleaseOSC() {
    let objNum = obj.getObjNumber()

    if obj.objType == .list {
      osc.releaseList(objNum)
    } else {
      osc.releaseScene(objNum)
    }
  }
}

//struct ShowObjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowObjectView(
//            obj: testShowObjects[1],
//            size: "small"
//        )
//    }
//}
