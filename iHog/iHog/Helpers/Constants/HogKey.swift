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

  case zero = 0
  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case five = 5
  case six = 6
  case seven = 7
  case eight = 8
  case nine = 9
  case backspace = 10
  case thru, full, at, minus, plus, slash, dot, enter
  case intensity
  case position, color, beam, effect, time, group, fixture
  case pig, assert, release, nextPage
  case fader, flash, pbGo, pbBack, pbHalt, pbChoose

  @ViewBuilder
  func label(masterNumber: Int?) -> some View {
    switch self {
      case .one:
        Text("1")
          .bold()
      case .two:
        Text("2")
          .bold()
      case .three:
        Text("3")
          .bold()
      case .four:
        Text("4")
          .bold()
      case .five:
        Text("5")
          .bold()
      case .six:
        Text("6")
          .bold()
      case .seven:
        Text("7")
          .bold()
      case .eight:
        Text("8")
          .bold()
      case .nine:
        Text("9")
          .bold()
      case .zero:
        Text("0")
          .bold()
      case .backspace:
        Image(systemName: "arrowshape.left.fill")
      case .thru:
        Image(systemName: "greaterthan")
          .bold()
      case .full:
        Text("Full")
          .bold()
      case .at:
        Text("@")
          .bold()
      case .minus:
        Image(systemName: "minus")
          .bold()
      case .plus:
        Image(systemName: "plus")
          .bold()
      case .slash:
        Text("/")
          .bold()
      case .dot:
        Text(".")
          .bold()
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
      case .pig:
        Text("Pig")
      case .assert:
        Text("Assert")
      case .release:
        Text("Release")
      case .nextPage:
        Text(">> Page")
      case .fader:
        Text("nothing")
      case .flash:
        Image(systemName: "lines.measurement.vertical")
      case .pbGo:
        Image(systemName: "play.fill")
      case .pbBack:
        Image(systemName: "play.fill")
          .rotationEffect(Angle(degrees: 180))
      case .pbHalt:
        Image(systemName: "pause.fill")
      case .pbChoose:
        Text("\(masterNumber ?? 0)")
    }
  }

  func oscAddress(masterNumber: Int? = nil) -> String {
    switch self {
      case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        guard let spelledOut: String = formatter.string(from: self.rawValue as NSNumber) else {
          print("NO VALID NUMBER")
          return "/hog/0/NO_VALID_NUMBER"
        }
        return "/hog/hardware/\(spelledOut)"
      case .backspace:
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
      case .pig:
        return "/hog/hardware/pig"
      case .assert:
        return "/hog/hardware/assert"
      case .release:
        return "/hog/hardware/release"
      case .nextPage:
        return "/hog/hardware/nextpage"
      case .fader:
        return "/hog/hardware/fader"
      case .flash:
        return "/hog/hardware/flash/\(masterNumber ?? 0)"
      case .pbGo:
        return "/hog/hardware/go/\(masterNumber ?? 0)"
      case .pbBack:
        return "/hog/hardware/goback/\(masterNumber ?? 0)"
      case .pbHalt:
        return "/hog/hardware/pause/\(masterNumber ?? 0)"
      case .pbChoose:
        return "/hog/hardware/choose/\(masterNumber ?? 0)"
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
