//
//  ShowObjectView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import OSLog
import SwiftUI

struct ShowObjectView: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(OSCManager.self) var oscManager

  var showObject: ShowObjectEntity
  var size: CGSize

  var strokeWidth: CGFloat {
    showObject.isOutlined ? 4.0 : 0.0
  }

  var body: some View {
    Button {
      sendOSC()
    } label: {
      VStack(alignment: .leading) {
        HStack {
          Text("\(showObject.viewObjectType) \(showObject.viewNumber)")
            .font(.footnote)
          Spacer()
        }
        Spacer()
        Text(showObject.viewTitle)
          .lineLimit(2)
          .bold()
          .multilineTextAlignment(.leading)
      }
      .padding()
      .frame(width: size.width, height: size.height)
      .background(backgroundColor)
      .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
      .overlay {
        RoundedRectangle(cornerRadius: 25.0, style: .continuous)
          .stroke(.blue, lineWidth: strokeWidth)
      }
    }
    .buttonStyle(.plain)
    .contextMenu(
      ContextMenu(menuItems: {
        Button(role: .destructive, action: deleteObject) {
          Label("Delete", systemImage: "trash")
        }
        .tint(.red)
        if showObject.safeObjType == .list || showObject.safeObjType == .scene {
          Button(action: deleteObject) {
            Label("Release", systemImage: "stop")
          }
        }
      })
    )
  }

  @ViewBuilder
  var backgroundColor: some View {
    if showObject.isOutlined {
      Color.primary.colorInvert()
    } else {
      Color.blue
    }
  }

  func deleteObject() {
    do {
      moc.delete(showObject)
      try moc.save()
    } catch {
      Logger.coredata.error("Couldn't delete object \(error)")
      moc.reset()
    }
  }

  func release() {
    guard let address = showObject.safeObjType.releaseAddress else {
      Logger.osc.error("No address found")
      return
    }
    oscManager.sendListSceneCommand(address: address, value: [showObject.number])
  }

  func sendOSC() {
    if showObject.safeObjType == .list || showObject.safeObjType == .scene {
      guard let address = showObject.safeObjType.goAddress else {
        Logger.osc.error("No address found")
        return
      }
      oscManager.sendListSceneCommand(address: address, value: [showObject.number])
      return
    }
    // for group only, clear the command line
    if showObject.safeObjType == .group {
      oscManager.push(address: HogKey.backspace.oscAddress())
      oscManager.release(address: HogKey.backspace.oscAddress())
      usleep(1000)
      oscManager.push(address: HogKey.backspace.oscAddress())
      oscManager.release(address: HogKey.backspace.oscAddress())
      usleep(1000)
    }
    // push/release button for object
    guard let address = showObject.safeObjType.pressAddress else {
      Logger.osc.error("No address found")
      return
    }
    oscManager.push(address: address)
    oscManager.release(address: address)
    usleep(1000)
    // push/release numbers for number
    for num in showObject.viewNumber {
      if num == "." {
        oscManager.push(address: HogKey.dot.oscAddress())
        oscManager.release(address: HogKey.dot.oscAddress())
      } else {
        guard let number = Int(num.lowercased()),
          let hogKey = HogKey(rawValue: number)
        else { return }
        oscManager.push(address: hogKey.oscAddress())
        oscManager.release(address: hogKey.oscAddress())
      }
      usleep(1000)
    }
    // push enter
    oscManager.push(address: HogKey.enter.oscAddress())
    oscManager.release(address: HogKey.enter.oscAddress())
    usleep(1000)
  }
}

#Preview {
  HStack {
    ShowObjectView(showObject: .mockNotOutlined, size: CGSize(width: 200, height: 200))
    ShowObjectView(showObject: .mock, size: CGSize(width: 200, height: 200))
  }
  .environment(\.managedObjectContext, .mock)
  .environment(OSCManager.mock)
}
