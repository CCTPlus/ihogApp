//
//  Constants.swift
//  iHog
//
//  Created by Jay Wilson on 8/27/22.
//

import Foundation
import UIKit
import SwiftUI

// MARK: Links

enum Links {
    static let appStore = URL(string: "https://apps.apple.com/us/app/ihog-osc-remote-for-hog-4/id1487580623")!
    static let terms = "https://ihog.notion.site/Terms-Conditions-fbb834695d2f409f8b03cce6102b3141"
    static let privacy = "https://ihog.notion.site/Privacy-Policy-c9021d2f3517465791b9ce9835551e8a"
}

// MARK: GENERAL
let BASE_CORNER_RADIUS: CGFloat     = 5
let DOUBLE_CORNER_RADIUS: CGFloat   = 10
let HALF_PADDING: CGFloat           = 5
let BASE_PADDING: CGFloat           = 10
let BASE_LINE_WIDTH: CGFloat        = 5

// MARK: FADERS or SLIDERS
let BASE_SLIDER_HEIGHT: CGFloat     = 250
let BASE_SLIDER_WIDTH: CGFloat      = 25
let BASE_THUMB_SIZE: CGFloat        = 30

// MARK: FRONT PANEL BUTTON SIZES
let BASE_BUTTON_SIZE: CGFloat       = 65
let SMALL_BUTTON_SIZE: CGFloat      = 50
let XL_BUTTON_WIDTH: CGFloat        = 200
let L_BUTTON_WIDTH: CGFloat         = BASE_BUTTON_SIZE*2.25

// MARK: OBJ BUTTON SIZES
let SMALL_OBJ_BUTTON_SIZE: CGFloat  = 50.0
let MEDIUM_OBJ_BUTTON_SIZE: CGFloat = 75.0
let LARGE_OBJ_BUTTON_SIZE: CGFloat  = 100.0
let XL_OBJ_BUTTON_SIZE: CGFloat     = 150.0

// MARK: MAX BUTTONS ACROSS
let SMALL_MAX_BUTTONS_ACROSS: Int   = 4
let MEDIUM_MAX_BUTTONS_ACROSS: Int  = 3
let LARGE_MAX_BUTTONS_ACROSS: Int   = 1
let XL_MAX_BUTTONS_ACROSS: Int      = 1

// MARK: COLOR OPTIONS
let OBJ_COLORS: [Color]             = [.red, .green, .blue, .yellow, .gray, .orange, .pink, .purple]

// MARK: SETTINGS NAV

enum SettingsNav:Hashable {
    case chooseShow
    case device
    case showSettings
    case about
    case programmerHardware
    case playbackHardware
    case focusHardware
    case playbackObject
    case programObject
    case custom
    case tipJar
    case oscLogView
    case userFeedbackView
}

// MARK: SETTING ENUMS
enum Settings: String {
    case timesLaunched
    case showOnboarding

    case chosenShowID

    case consoleIP
    case serverPort
    case clientPort
    case isOSCOn

    case encoderWheelPrecision
    case isEncoderFine
    case isNanoModeOn
    case isHapticOn

    // MARK: Button Group
    case buttonColorGroup
    case buttonSizeGroup
    case buttonsAcrossGroup
    case isButtonFilledGroup

    // MARK: Button Palette
    case buttonColorPalette
    case buttonSizePalette
    case buttonsAcrossPalette
    case isButtonFilledPalette

    // MARK: Button List
    case buttonColorList
    case buttonSizeList
    case buttonsAcrossList
    case isButtonFilledList

    // MARK: Button Scene
    case buttonColorScene
    case buttonSizeScene
    case buttonsAcrossScene
    case isButtonFilledScene

    // MARK: Feature Unlocks
    case puntPageIsEnabled
}

/// BUTTON NAME ENUMS
enum ButtonFunctionNames: String {
    // MARK: PLAYBACKS
    case pause
    case goback
    case go
    case flash
    case choose
    case master
    // MARK: MAIN BUTTONS (AKA BIG PLAYBAK BUTTONS)
    case mainchoose
    case mainback
    case mainhalt
    case maingo
    case assert
    case release
    case nextpage
    case backpage
    case skipback
    case skipfwd
    // MARK: PROGRAMMING
    case numberpad
    case backspace
    case slash
    case minus
    case plus
    case thru
    case full
    case at
    case period
    case enter
    // OBJECT BUTTONS
    case live
    case scene
    case cue
    case macro
    case list
    case page
    // ACTION BUTTONS
    case delete
    case move
    case copy
    case update
    case merge
    case record
    // UTILITY BUTTONS
    case setup
    case goto
    case set
    case pig
    case fan
    case open
    // KIND KEYS
    case intensity
    case position
    case colour
    case beam
    case effect
    case time
    case group
    case fixture
    // Select Buttons
    case back
    case all
    case next
    // HBC
    case highlight
    case blind
    case clear
    // Function Keys
    case h1
    case h2
    case h3
    case h4
    case h5
    case h6
    case h7
    case h8
    case h9
    case h10
    case h11
    case h12
}

