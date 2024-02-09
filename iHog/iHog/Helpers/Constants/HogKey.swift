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
  case back, all, next
  case h1, h2, h3, h4, h5, h6, h7, h8, h9, h10, h11, h12
  case highlight, blind, clear
  case live, scene, cue, macro, list, page
  // ACTION BUTTONS
  case delete, move, copy, update, merge, record
  // UTILITY BUTTONS
  case setup, goto, set, fan, open

  var textRepresentation: String {
    switch self {
      case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        guard let spelledOut: String = formatter.string(from: self.rawValue as NSNumber) else {
          return "NO VALID NUMBER"
        }
        return "\(spelledOut)"
      case .backspace:
        return "backspace"
      case .thru:
        return "thru"
      case .full:
        return "full"
      case .at:
        return "at"
      case .minus:
        return "minus"
      case .plus:
        return "plus"
      case .slash:
        return "slash"
      case .dot:
        return "period"
      case .enter:
        return "enter"
      case .intensity:
        return "intensity"
      case .position:
        return "position"
      case .color:
        return "color"
      case .beam:
        return "beam"
      case .effect:
        return "effects"
      case .time:
        return "time"
      case .group:
        return "group"
      case .fixture:
        return "fixture"
      case .pig:
        return "pig"
      case .assert:
        return "assert"
      case .release:
        return "release"
      case .nextPage:
        return "nextpage"
      case .fader:
        return "fader"
      case .flash:
        return "flash"
      case .pbGo:
        return "go"
      case .pbBack:
        return "goback"
      case .pbHalt:
        return "pause"
      case .pbChoose:
        return "choose"
      case .back:
        return "back"
      case .all:
        return "all"
      case .next:
        return "next"
      case .h1:
        return "h1"
      case .h2:
        return "h2"
      case .h3:
        return "h3"
      case .h4:
        return "h4"
      case .h5:
        return "h5"
      case .h6:
        return "h6"
      case .h7:
        return "h7"
      case .h8:
        return "h8"
      case .h9:
        return "h9"
      case .h10:
        return "h10"
      case .h11:
        return "h11"
      case .h12:
        return "h12"
      case .highlight:
        return "highlight"
      case .blind:
        return "blind"
      case .clear:
        return "clear"
      case .live:
        return "live"
      case .scene:
        return "scene"
      case .cue:
        return "cue"
      case .macro:
        return "macro"
      case .list:
        return "list"
      case .page:
        return "page"
      case .delete:
        return "delete"
      case .move:
        return "move"
      case .copy:
        return "copy"
      case .update:
        return "update"
      case .merge:
        return "merge"
      case .record:
        return "record"
      case .setup:
        return "setup"
      case .goto:
        return "goto"
      case .set:
        return "set"
      case .fan:
        return "fan"
      case .open:
        return "open"
    }
  }

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
      case .intensity:
        Text("Intens")
      case .position:
        Text("Positn")
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
      case .h1, .h2, .h3, .h4, .h5, .h6, .h7, .h8, .h9, .h10, .h11, .h12:
        Text("H\nh")
      case .record:
        Text("REC")
      default:
        Text(textRepresentation.uppercased())
    }
  }

  func oscAddress(masterNumber: Int? = nil) -> String {
    switch self {
      case .flash, .pbGo, .pbBack, .pbHalt, .pbChoose:
        return "/hog/hardware/\(textRepresentation)/\(masterNumber ?? 0)"
      default:
        return "/hog/hardware/\(textRepresentation)"
    }
  }
}
