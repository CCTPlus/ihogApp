//
//  HogKey.swift
//  iHog
//
//  Created by Jay on 2/6/24.
//

import Foundation
import SwiftUI

enum HogKey: Int, Identifiable {
  var id: Int {
    self.rawValue
  }

  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case five = 5
  case six = 6
  case seven = 7
  case eight = 8
  case nine = 9
  case zero = 0
  case back = 10
  case thru, full, at, minus, plus, slash, dot, enter
  case intensity = 20
  case position, color, beam, effect, time, group, fixture

  @ViewBuilder
  var label: some View {
    switch self {
      case .one:
        Image(systemName: "1.square")
      case .two:
        Image(systemName: "2.square")
      case .three:
        Image(systemName: "3.square")
      case .four:
        Image(systemName: "4.square")
      case .five:
        Image(systemName: "5.square")
      case .six:
        Image(systemName: "6.square")
      case .seven:
        Image(systemName: "7.square")
      case .eight:
        Image(systemName: "8.square")
      case .nine:
        Image(systemName: "9.square")
      case .zero:
        Image(systemName: "0.square")
      case .back:
        Image(systemName: "arrowshape.left.fill")
      case .thru:
        Image(systemName: "greaterthan.square")
      case .full:
        Image(systemName: "arrowshape.up.fill")
      case .at:
        Text("@")
      case .minus:
        Image(systemName: "minus.square")
      case .plus:
        Image(systemName: "plus.square")
      case .slash:
        Text("/")
      case .dot:
        Image(systemName: "dot.square")
      case .enter:
        Text("Enter")
      case .intensity:
        Text("Intens")
      case .position:
        Text("Position")
      case .color:
        Text("Colour")
      case .beam:
        Text("Beam")
      case .effect:
        Text("Effect")
      case .time:
        Text("Time")
      case .group:
        Text("Group")
      case .fixture:
        Text("Fixture")
    }
  }

  var oscAddress: String {
    switch self {
      case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        guard let spelledOut: String = formatter.string(from: self.rawValue as NSNumber) else {
          print("NO VALID NUMBER")
          return "/hog/0/NO_VALID_NUMBER"
        }
        return "/hog/hardware/\(spelledOut)"
      case .back:
        return "/hog/hardware/backspace"
      case .thru:
        return "/hog/hardware/thru"
      case .full:
        return "/hog/hardware/full"
      case .at:
        return "/hog/hardware/at"
      case .minus:
        return "/hog/hardware/minus"
      case .plus:
        return "/hog/hardware/plus"
      case .slash:
        return "/hog/hardware/slash"
      case .dot:
        return "/hog/hardware/period"
      case .enter:
        return "/hog/hardware/period"
      case .intensity:
        return "/hog/hardware/intensity"
      case .position:
        return "/hog/hardware/position"
      case .color:
        return "/hog/hardware/colour"
      case .beam:
        return "/hog/hardware/beam"
      case .effect:
        return "/hog/hardware/effects"
      case .time:
        return "/hog/hardware/time"
      case .group:
        return "/hog/hardware/group"
      case .fixture:
        return "/hog/hardware/fixture"
    }
  }
}

/*
static let go = "/hog/playback/go/"
static let halt = "/hog/playback/halt/"
static let back = "/hog/playback/back/"
static let release = "/hog/playback/release/"
static let hardware = "/hog/hardware/"
static let pig = "/hog/hardware/pig"
static let hRelease = "/hog/hardware/release"
static let choose = "/hog/hardware/choose/"
static let goHardware = "/hog/hardware/go/"
static let pauseHardware = "/hog/hardware/pause/"
static let backHardware = "/hog/hardware/goback/"
static let flashHardware = "/hog/hardware/flash/"
static let fader = "/hog/hardware/fader/"
static let encoderWheelButton = "/hog/hardware/ewheelbutton/"
static let encoderWheel = "/hog/hardware/encoderwheel/"
static let period = "/hog/hardware/period"
static let enter = "/hog/hardware/enter"
static let status = "/hog/status/"

static func keypad(number: Int) throws -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    guard let spelledOut: String = formatter.string(from: number as NSNumber) else {
        throw OSCCommandPathError.noValidButton
    }
    return "/hog/hardware/\(spelledOut)"
}
*/
