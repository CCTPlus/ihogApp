//
//  PlaybackObjects.swift
//  iHog
//
//  Created by Jay Wilson on 9/23/20.
//

import CoreData
import SwiftUI

struct PlaybackObjects: View {
  @AppStorage(Settings.chosenShowID.rawValue) var chosenShowID: String = ""
  // MARK: LIST Default Values
  @AppStorage(Settings.buttonColorList.rawValue) var buttonColorList = 0
  @AppStorage(Settings.buttonSizeList.rawValue) var buttonSizeList = 0
  @AppStorage(Settings.buttonsAcrossList.rawValue) var buttonsAcrossList = 3
  @AppStorage(Settings.isButtonFilledList.rawValue) var buttonFilledList = false
  // MARK: SCENE Default Values
  @AppStorage(Settings.buttonColorScene.rawValue) var buttonColorScene = 2
  @AppStorage(Settings.buttonSizeScene.rawValue) var buttonSizeScene = 0
  @AppStorage(Settings.buttonsAcrossScene.rawValue) var buttonsAcrossScene = 3
  @AppStorage(Settings.isButtonFilledScene.rawValue) var buttonFilledScene = false

  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  @State private var listObjects: [ShowObject] = []
  @State private var sceneObjects: [ShowObject] = []

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
    .onAppear {
      getAllObjects()
    }
  }

  // MARK: add List
  func addList() {
    let newList = ShowObject(
      id: UUID(),
      objType: .list,
      number: Double(show.lists.count + 1),
      objColor: OBJ_COLORS[buttonColorList].description,
      isOutlined: !buttonFilledList
    )

    show.addList(newList)

    let obj = CDShowObjectEntity(context: viewContext)
    obj.id = newList.id
    obj.isOutlined = newList.isOutlined
    obj.number = newList.number
    obj.objColor = newList.objColor
    obj.objType = newList.objType.rawValue
    obj.showID = chosenShowID

    do {
      print("Save")
      try viewContext.save()
    } catch {
      Analytics.shared.logError(with: error, for: .coreData)
    }
  }

  // MARK: add Scene
  func addScene() {
    let newScene = ShowObject(
      id: UUID(),
      objType: .scene,
      number: Double(show.scenes.count + 1),
      objColor: OBJ_COLORS[buttonColorScene].description,
      isOutlined: !buttonFilledScene
    )

    show.addScene(newScene)

    let obj = CDShowObjectEntity(context: viewContext)
    obj.id = newScene.id
    obj.isOutlined = newScene.isOutlined
    obj.number = newScene.number
    obj.objColor = newScene.objColor
    obj.objType = newScene.objType.rawValue
    obj.showID = chosenShowID

    do {
      try viewContext.save()
    } catch {
      Analytics.shared.logError(with: error, for: .coreData)
    }
  }

  // MARK: Release all function
  // TODO: Add OSC
  func releaseAll() {
    print("Release all")
  }

  // MARK: Get all objects
  func getAllObjects() {
    show.lists = []
    show.scenes = []

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowObjectEntity")
    fetchRequest.predicate = NSPredicate(format: "showID == %@", chosenShowID)

    do {
      let results = try viewContext.fetch(fetchRequest) as! [CDShowObjectEntity]
      for showObj in results {
        // create temp object
        var tempOBJ = ShowObject(
          id: showObj.id!,
          objType: .list,
          number: showObj.number,
          name: showObj.name,
          objColor: showObj.objColor ?? "gray",
          isOutlined: showObj.isOutlined
        )
        // determine object type and add to proper list
        switch showObj.objType {
          case ShowObjectType.list.rawValue:
            tempOBJ.objType = .list
            show.addList(tempOBJ)
          case ShowObjectType.scene.rawValue:
            tempOBJ.objType = .scene
            show.addScene(tempOBJ)
          default:
            continue
        }
      }
      show.lists.sort(by: { $0.number < $1.number })
      show.scenes.sort(by: { $0.number < $1.number })
    } catch {
      Analytics.shared.logError(with: error, for: .coreData)
    }
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
