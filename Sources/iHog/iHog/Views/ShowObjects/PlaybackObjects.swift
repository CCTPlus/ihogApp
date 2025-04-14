//
//  PlaybackObjects.swift
//  iHog
//
//  Created by Jay Wilson on 9/23/20.
//

import CoreData
import SwiftUI

struct PlaybackObjects: View {
  @AppStorage(AppStorageKey.chosenShowID.rawValue) var chosenShowID: String = ""
  // MARK: LIST Default Values
  @AppStorage(AppStorageKey.buttonColorList.rawValue) var buttonColorList = 0
  @AppStorage(AppStorageKey.buttonSizeList.rawValue) var buttonSizeList = 0
  @AppStorage(AppStorageKey.buttonsAcrossList.rawValue) var buttonsAcrossList = 3
  @AppStorage(AppStorageKey.isButtonFilledList.rawValue) var buttonFilledList = false
  // MARK: SCENE Default Values
  @AppStorage(AppStorageKey.buttonColorScene.rawValue) var buttonColorScene = 2
  @AppStorage(AppStorageKey.buttonSizeScene.rawValue) var buttonSizeScene = 0
  @AppStorage(AppStorageKey.buttonsAcrossScene.rawValue) var buttonsAcrossScene = 3
  @AppStorage(AppStorageKey.isButtonFilledScene.rawValue) var buttonFilledScene = false

  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  @ObservedObject var show: ChosenShow

  // Size selections
  let sizes: [String] = ["small", "medium", "large", "extra large"]

  fileprivate func returnStackedView() -> some View {
    return Group {
      ObjectGrid(
        size: sizes[buttonSizeList],
        buttonsAcross: getMaxButtonSize()[0],
        objects: show.lists,
        show: show
      )
      // MARK: Scenes
      ObjectGrid(
        size: sizes[buttonSizeScene],
        buttonsAcross: getMaxButtonSize()[1],
        objects: show.scenes,
        show: show
      )
    }
  }

  fileprivate func returnSideBySideView() -> some View {
    return Group {
      HStack {
        ObjectGrid(
          size: sizes[buttonSizeList],
          buttonsAcross: getMaxButtonSize()[0],
          objects: show.lists,
          show: show
        )
        // MARK: Scenes
        ObjectGrid(
          size: sizes[buttonSizeScene],
          buttonsAcross: getMaxButtonSize()[1],
          objects: show.scenes,
          show: show
        )
      }
    }
  }

  var body: some View {
    VStack {
      // MARK: Toolbar
      HStack {
        Button(action: addList) {
          VStack {
            Image(systemName: "plus.rectangle")
            Text("Add List")
          }
        }
        Spacer()
        Button(action: releaseAll) {
          VStack {
            Image(systemName: "xmark.square")
            Text("Release All")
          }
        }
        .foregroundColor(.red)
        Spacer()
        Button(action: addScene) {
          VStack {
            Image(systemName: "plus.rectangle")
            Text("Add Scene")
          }
        }
      }
      // MARK: Lists
      if horizontalSizeClass == .compact {
        if verticalSizeClass == .compact {
          returnSideBySideView()
        } else {
          returnStackedView()
        }
      } else {
        returnSideBySideView()
      }
    }
    .padding()
  }

  // MARK: add List
  func addList() {
    Task {
      let color = OBJ_COLORS[buttonColorList].description
      let isOutlined = !buttonFilledList
      do {
        try await show
          .createObject(color: color, type: .list, isOutlined: isOutlined)
      } catch {
        Analytics.shared.logError(with: error, for: .coreData, level: .critical)
      }
    }
  }

  // MARK: add Scene
  func addScene() {
    Task {
      let color = OBJ_COLORS[buttonColorScene].description
      let isOutlined = !buttonFilledScene
      do {
        try await show
          .createObject(color: color, type: .scene, isOutlined: isOutlined)
      } catch {
        Analytics.shared.logError(with: error, for: .coreData, level: .critical)
      }
    }
  }

  // MARK: Release all function
  // TODO: Add OSC
  func releaseAll() {
    print("Release all")
  }

  /// Sets a max button size
  /// - Returns: Integer array with 2 items inside. First index is lists, second index is scenes
  func getMaxButtonSize() -> [Int] {
    switch horizontalSizeClass {
      case .compact:
        return [getListButtonsAcross(), getSceneButtonsAcross()]
      default:
        return [getListButtonsAcross(), getSceneButtonsAcross()]
    }
  }

  func getSceneButtonsAcross() -> Int {
    //        print("Scene buttons \(buttonsAcrossScene)")
    switch buttonSizeScene {
      // small
      case 0:
        if buttonsAcrossScene <= SMALL_MAX_BUTTONS_ACROSS {
          return buttonsAcrossScene
        }
        return SMALL_MAX_BUTTONS_ACROSS
      // medium
      case 1:
        if buttonsAcrossScene <= MEDIUM_MAX_BUTTONS_ACROSS {
          return buttonsAcrossScene
        }
        return MEDIUM_MAX_BUTTONS_ACROSS
      // large
      case 2:
        return LARGE_MAX_BUTTONS_ACROSS
      // extra large
      default:
        return XL_MAX_BUTTONS_ACROSS
    }
  }

  func getListButtonsAcross() -> Int {
    //        print("List buttons \(buttonsAcrossList)")
    switch buttonSizeList {
      // small
      case 0:
        if buttonsAcrossList <= SMALL_MAX_BUTTONS_ACROSS {
          return buttonsAcrossList
        }
        return SMALL_MAX_BUTTONS_ACROSS
      // medium
      case 1:
        if buttonsAcrossList <= MEDIUM_MAX_BUTTONS_ACROSS {
          return buttonsAcrossList
        }
        return MEDIUM_MAX_BUTTONS_ACROSS
      // large
      case 2:
        return LARGE_MAX_BUTTONS_ACROSS
      // extra large
      default:
        return XL_MAX_BUTTONS_ACROSS
    }
  }
}

// MARK: PREVIEW
//struct PlaybackObjects_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaybackObjects()
//    }
//}
