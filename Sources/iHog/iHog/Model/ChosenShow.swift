//
//  ChosenShow.swift
//  iHog
//
//  Created by Jay Wilson on 6/9/21.
//

import CoreData
import Foundation

class ChosenShow: ObservableObject {
  @Published var scenes: [ShowObject]
  @Published var lists: [ShowObject]
  @Published var groups: [ShowObject]
  @Published var palettes: [ShowObject]
  @Published var showName: String = ""

  var playbackObjects: [ShowObject] {
    return lists + scenes
  }

  var showID: UUID
  var showObjectRepository: ShowObjectRepository
  var showRepository: ShowRepository

  init(
    showID: UUID,
    showObjectRepository: ShowObjectRepository,
    showRepository: ShowRepository
  ) {
    scenes = []
    lists = []
    groups = []
    palettes = []
    self.showID = showID
    self.showObjectRepository = showObjectRepository
    self.showRepository = showRepository
    getShowInfo()
    getAllObjects()
    HogLogger.log(category: .show)
      .info(
        "Show \(showID) initialized with \(self.scenes.count) scenes, \(self.lists.count) lists, \(self.groups.count) groups, and \(self.palettes.count) palettes"
      )
    // Needed so that show objects get added to the proper show since I'm not using relationships correctly
    UserDefaults.standard
      .set(showID.uuidString, forKey: AppStorageKey.chosenShowID.rawValue)
  }

  func getShowInfo() {
    Task {
      do {
        let show = try await showRepository.getShow(by: showID)
        await MainActor.run {
          self.showName = show.name
        }
      } catch {
        Analytics.shared.logError(with: error, for: .show, level: .warning)
      }
    }
  }

  func getAllObjects() {
    Task {
      do {
        async let foundScenes = try showObjectRepository.getAllObjects(
          from: showID,
          of: .scene
        )
        async let foundLists = try showObjectRepository.getAllObjects(
          from: showID,
          of: .list
        )
        async let foundGroups = try showObjectRepository.getAllObjects(
          from: showID,
          of: .group
        )
        async let foundIntPalettes = try showObjectRepository.getAllObjects(
          from: showID,
          of: .intensity
        )
        async let foundColorPalettes = try showObjectRepository.getAllObjects(
          from: showID,
          of: .color
        )
        async let foundPositionPalettes = try showObjectRepository.getAllObjects(
          from: showID,
          of: .position
        )
        async let foundBeamPalettes = try showObjectRepository.getAllObjects(
          from: showID,
          of: .beam
        )
        async let foundEffectPalettes = try showObjectRepository.getAllObjects(
          from: showID,
          of: .effect
        )

          let allLists = try await foundLists
          let allScenes = try await foundScenes
          let allGroups = try await foundGroups
          let allIntPalettes = try await foundIntPalettes
          let allBeamPalettes = try await foundBeamPalettes
          let allColorPalettes = try await foundColorPalettes
          let allPositionPalettes = try await foundPositionPalettes
          let allEffectPalettes = try await foundEffectPalettes

          await MainActor.run {
              allLists.forEach { obj in
                  addList(obj)
              }

              allScenes.forEach { obj in
                  addScene(obj)
              }

              allGroups.forEach { obj in
                  addGroup(obj)
              }

              allIntPalettes.forEach { obj in
                  addPalette(obj)
              }

              allBeamPalettes.forEach { obj in
                  addPalette(obj)
              }

              allColorPalettes.forEach { obj in
                  addPalette(obj)
              }

              allPositionPalettes.forEach { obj in
                  addPalette(obj)
              }

              allEffectPalettes.forEach { obj in
                  addPalette(obj)
              }
          }
      } catch {
        Analytics.shared.logError(with: error, for: .show, level: .warning)
      }
    }
  }

  func createObject(color: String, type: ShowObjectType, isOutlined: Bool) async throws {
    let newObject =
      try await showObjectRepository
      .createObject(
        for: showID,
        name: nil,
        type: type,
        color: color,
        isOutlined: isOutlined
      )
    await MainActor.run {
      switch type {
        case .group:
          addGroup(newObject)
        case .intensity, .position, .color, .beam, .effect:
          addPalette(newObject)
        case .list:
          addList(newObject)
        case .scene:
          addScene(newObject)
        default:
          Analytics.shared
            .logError(
              with: HogError.objectTypeNoteFoundCreating,
              for: .show,
              level: .warning
            )
      }
    }
  }

  func deleteObject(by id: UUID, objType: ShowObjectType) async throws {
    try await showObjectRepository.delete(by: id)
    await MainActor.run {
      switch objType {
        case .group:
          groups.removeAll(where: { $0.id == id })
        case .intensity, .position, .color, .beam, .effect:
          palettes.removeAll(where: { $0.id == id })
        case .list:
          lists.removeAll(where: { $0.id == id })
        case .scene:
          lists.removeAll(where: { $0.id == id })
        case .batch, .macro, .plot:
          Analytics.shared
            .logError(
              with: HogError.objectTypeNoteFoundDeleting,
              for: .show,
              level: .warning
            )
      }
    }
  }

  func updateObject(_ obj: ShowObject) async throws {
    let updatedObj = try await showObjectRepository.update(object: obj)
    await MainActor.run {
      switch obj.objType {
        case .scene:
          updateScene(updatedObj)
        case .list:
          updateList(updatedObj)
        case .group:
          updateGroup(updatedObj)
        case .intensity, .position, .color, .beam, .effect:
          updatePalette(updatedObj)
        case .batch, .macro, .plot:
          Analytics.shared
            .logError(
              with: HogError.objectTypeNoteFoundEditing,
              for: .show,
              level: .warning
            )
      }
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
        HogLogger.log(category: .show).error("Update shouldn't have been called")
      }
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

  // MARK: Groups
  func addGroup(_ obj: ShowObject) {
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
}
