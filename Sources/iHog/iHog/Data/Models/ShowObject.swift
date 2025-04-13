//
//  ShowObject.swift
//  iHog
//
//  Created by Jay Wilson on 9/21/20.
//

import Foundation

public enum ShowObjectType: String {
  //programming objects
  case group
  case intensity
  case position
  case color = "colour"
  case beam
  case effect

  // playback objects
  case list
  case scene
  case batch

  // others
  case macro
  case plot
}

/// An object in the show that is used for programming or playback.
struct ShowObject: Identifiable, Hashable {
  var id: UUID
  var objType: ShowObjectType
  var number: Double
  var name: String?
  var objColor: String
  var isOutlined: Bool

  init(
    id: UUID = UUID(),
    objType: ShowObjectType,
    number: Double,
    name: String? = nil,
    objColor: String,
    isOutlined: Bool = true
  ) {
    self.id = id
    self.objType = objType
    self.number = number
    self.name = name
    self.objColor = objColor
    self.isOutlined = isOutlined
  }

  init(from entity: ShowObjectEntity) {
    self.objType = ShowObjectType(rawValue: entity.objType ?? "") ?? .group
    self.id = entity.id ?? UUID()
    self.number = entity.number ?? 0
    self.name = entity.name
    self.objColor = entity.objColor ?? "red"
    self.isOutlined = entity.isOutlined ?? true
  }

  // Adjust values
  mutating func setName(_ newName: String?) {
    guard let name = newName else {
      return
    }
    self.name = name
  }

  mutating func setNumber(_ newNumber: Double) {
    number = newNumber
  }

  mutating func setOutline(_ newOutlineState: Bool) {
    isOutlined = newOutlineState
  }

  mutating func setColor(_ newColor: String) {
    objColor = newColor
  }

  // Retrieve values
  /// Used to return the name of the object
  /// - Returns: Name of object
  func getName() -> String {
    if let objectName = name {
      return objectName
    }
    return objType.rawValue.localizedCapitalized + " " + getObjNumber()
  }

  /// Used to return the number of the object.
  /// - Returns: Object Number
  func getObjNumber() -> String {
    let numString: String = String(format: "%g", number)

    return numString
  }

  func getOutlineState() -> Bool {
    return isOutlined
  }

  func getShortType() -> String {
    switch objType {
      case .group:
        return "G"
      case .intensity:
        return "I"
      case .position:
        return "P"
      case .color:
        return "C"
      case .beam:
        return "B"
      case .effect:
        return "E"
      case .list:
        return "L"
      case .scene:
        return "S"
      default:
        // NO TYPE FOUND
        Analytics.shared
          .logError(
            with: HogError.objectTypeNotFound,
            for: .show,
            level: .warning
          )
        return "NTF"
    }
  }

  func getColorString() -> String {
    return objColor
  }

  func getColor() -> Int {
    var colorIndex = 0
    switch objColor {
      case "red":
        colorIndex = 0
      case "green":
        colorIndex = 1
      case "blue":
        colorIndex = 2
      case "yellow":
        colorIndex = 3
      case "gray":
        colorIndex = 4
      case "orange":
        colorIndex = 5
      case "pink":
        colorIndex = 6
      case "purple":
        colorIndex = 7
      default:
        colorIndex = 0
    }

    return colorIndex
  }
}

let testShowObjects: [ShowObject] = [
  ShowObject(objType: ShowObjectType.group, number: 1, objColor: "red"),
  ShowObject(objType: ShowObjectType.position, number: 1, objColor: "red", isOutlined: false),
  ShowObject(objType: ShowObjectType.position, number: 2.0, objColor: "red"),
  ShowObject(objType: ShowObjectType.position, number: 10.0, objColor: "red"),
  ShowObject(objType: ShowObjectType.position, number: 21.0, objColor: "red", isOutlined: false),
  ShowObject(objType: ShowObjectType.intensity, number: 21.0, objColor: "red"),
  ShowObject(objType: ShowObjectType.color, number: 21.0, objColor: "red"),
  ShowObject(objType: ShowObjectType.beam, number: 21.0, objColor: "red", isOutlined: false),
  ShowObject(objType: ShowObjectType.beam, number: 2.0, objColor: "red"),
  ShowObject(objType: ShowObjectType.beam, number: 103.0, objColor: "red"),
]
