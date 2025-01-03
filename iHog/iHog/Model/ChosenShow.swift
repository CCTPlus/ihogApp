//
//  ChosenShow.swift
//  iHog
//
//  Created by Jay Wilson on 6/9/21.
//

import CoreData
import Foundation
import SwiftUI

class ChosenShow: ObservableObject {
  @Published var scenes: [ShowObject]
  @Published var lists: [ShowObject]
  @Published var groups: [ShowObject]
  @Published var palettes: [ShowObject]
  @Published var showName: String = ""

  var playbackObjects: [ShowObject] {
    return lists + scenes
  }

  var persistence: PersistenceController
  var showID: String

  init(showID: String, persistence: PersistenceController) {
    scenes = []
    lists = []
    groups = []
    palettes = []
    self.persistence = persistence
    self.showID = showID
    getShowInfo()
    getAllObjects()
    HogLogger.log(category: .show)
      .info(
        "Show \(showID) initialized with \(self.scenes.count) scenes, \(self.lists.count) lists, \(self.groups.count) groups, and \(self.palettes.count) palettes"
      )
    UserDefaults.standard.set(showID, forKey: AppStorageKey.chosenShowID.rawValue)
  }

  func getShowInfo() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowEntity")
    fetchRequest.predicate = NSPredicate(format: "id == %@", showID)
    do {
      let results =
        try persistence.container.viewContext.fetch(fetchRequest) as? [CDShowEntity]
      guard let show = results?.first else {
        HogLogger.log(category: .show).error("No show found with ID \(self.showID)")
        return
      }
      showName = show.name ?? "No name"
    } catch {
      HogLogger.log(category: .show).error("Error fetching show info: \(error)")
    }
  }

  func getAllObjects() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowObjectEntity")
    fetchRequest.predicate = NSPredicate(format: "showID == %@", showID)
    do {
      guard
        let results =
          try persistence.container.viewContext.fetch(fetchRequest) as? [CDShowObjectEntity]
      else {
        HogLogger.log(category: .coreData).error("🚨 \(#function) could not perform fetch")
        return
      }
      for showObj in results {
        var newObj = ShowObject(
          id: showObj.id!,
          objType: .group,
          number: showObj.number,
          name: showObj.name,
          objColor: showObj.objColor ?? "red",
          isOutlined: showObj.isOutlined
        )
        switch showObj.objType {
          case ShowObjectType.group.rawValue:
            addGroup(newObj)
          case ShowObjectType.intensity.rawValue:
            newObj.objType = .intensity
            addPalette(newObj)
          case ShowObjectType.position.rawValue:
            newObj.objType = .position
            addPalette(newObj)
          case ShowObjectType.color.rawValue:
            newObj.objType = .color
            addPalette(newObj)
          case ShowObjectType.beam.rawValue:
            newObj.objType = .beam
            addPalette(newObj)
          case ShowObjectType.effect.rawValue:
            newObj.objType = .effect
            addPalette(newObj)
          case ShowObjectType.list.rawValue:
            newObj.objType = .list
            addList(newObj)
          case ShowObjectType.scene.rawValue:
            newObj.objType = .scene
            addScene(newObj)
          default:
            continue
        }
      }
      groups.sort(by: { $0.number < $1.number })
      palettes.sort(by: { $0.number < $1.number })
      lists.sort(by: { $0.number < $1.number })
      scenes.sort(by: { $0.number < $1.number })
    } catch {
      Analytics.shared.logError(with: error, for: .coreData, level: .critical)
    }
  }

  // MARK: Scenes
  func addScene(_ obj: ShowObject) {
    if obj.objType == .scene {
      scenes.append(obj)
    }
  }

  func updateScene(_ obj: ShowObject) {
    if obj.objType == .scene {
      let index = scenes.firstIndex { $0.id == obj.id }
      if index != nil {
        scenes[index!].setName(obj.name)
        scenes[index!].setNumber(obj.number)
        scenes[index!].setColor(obj.getColorString())
        scenes[index!].setOutline(obj.getOutlineState())
      } else {
        print("UPDATE SHOULD NOT HAVE BEEN CALLED")
      }
    }
  }

  func removeScene(_ obj: ShowObject) {
    if obj.objType == .scene {
      scenes.removeAll { $0.id == obj.id }
    }
  }
  // MARK: Lists
  func addList(_ obj: ShowObject) {
    if obj.objType == .list {
      lists.append(obj)
    }
  }

  func updateList(_ obj: ShowObject) {
    if obj.objType == .list {
      let index = lists.firstIndex { $0.id == obj.id }
      if index != nil {
        lists[index!].setName(obj.name)
        lists[index!].setNumber(obj.number)
        lists[index!].setColor(obj.getColorString())
        lists[index!].setOutline(obj.getOutlineState())
      } else {
        print("UPDATE SHOULD NOT HAVE BEEN CALLED")
      }
    }
  }

  func removeList(_ obj: ShowObject) {
    if obj.objType == .list {
      lists.removeAll { $0.id == obj.id }
    }
  }

  // MARK: Groups
  func addGroup(_ obj: ShowObject) {
    HogLogger.log(category: .show).debug("🐛 Adding \(obj.number) group")
    if obj.objType == .group {
      groups.append(obj)
    }
  }

  func updateGroup(_ obj: ShowObject) {
    if obj.objType == .group {
      let index = groups.firstIndex { $0.id == obj.id }
      if index != nil {
        groups[index!].setName(obj.name)
        groups[index!].setNumber(obj.number)
        groups[index!].setColor(obj.getColorString())
        groups[index!].setOutline(obj.getOutlineState())
      } else {
        print("UPDATE SHOULD NOT HAVE BEEN CALLED")
      }
    }
  }

  func removeGroup(_ obj: ShowObject) {
    if obj.objType == .group {
      groups.removeAll { $0.id == obj.id }
    }
  }

  // MARK: Palettes
  func addPalette(_ obj: ShowObject) {
    switch obj.objType {
      case .intensity, .color, .position, .effect, .beam:
        palettes.append(obj)
      default:
        break
    }
  }

  func updatePalette(_ obj: ShowObject) {
    switch obj.objType {
      case .intensity, .color, .position, .effect, .beam:
        let index = palettes.firstIndex { $0.id == obj.id }
        if index != nil {
          palettes[index!].setName(obj.name)
          palettes[index!].setNumber(obj.number)
          palettes[index!].setColor(obj.getColorString())
          palettes[index!].setOutline(obj.getOutlineState())
        } else {
          print("UPDATE SHOULD NOT HAVE BEEN CALLED")
        }
      default:
        break
    }
  }

  func removePalette(_ obj: ShowObject) {
    switch obj.objType {
      case .intensity, .color, .position, .effect, .beam:
        palettes.removeAll { $0.id == obj.id }
      default:
        break
    }
  }
}
