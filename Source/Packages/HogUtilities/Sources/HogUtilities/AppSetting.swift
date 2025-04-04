//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/4/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

public enum AppSetting: String {
  case timesLaunched
  case showOnboarding

  case chosenShowID

  case consoleIP
  case serverPort
  case clientPort
  case isOSCOn
  case selectedInterfaceName

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

  public var defaultValue: Any {
    switch self {
      case .consoleIP: "172.31.0.1"
      case .timesLaunched: 0
      case .showOnboarding: true
      case .chosenShowID: ""
      case .serverPort: "7001"
      case .clientPort: "7002"
      case .isOSCOn: false
      case .selectedInterfaceName: ""
      case .encoderWheelPrecision: 2.0
      case .isEncoderFine: false
      case .isNanoModeOn: false
      case .isHapticOn: true
      case .buttonColorGroup: 0
      case .buttonSizeGroup: 0
      case .buttonsAcrossGroup: 3
      case .isButtonFilledGroup: false
      case .buttonColorPalette: 2
      case .buttonSizePalette: 0
      case .buttonsAcrossPalette: 3
      case .isButtonFilledPalette: false
      case .buttonColorList: 0
      case .buttonSizeList: 0
      case .buttonsAcrossList: 3
      case .isButtonFilledList: false
      case .buttonColorScene: 0
      case .buttonSizeScene: 0
      case .buttonsAcrossScene: 3
      case .isButtonFilledScene: false
      case .puntPageIsEnabled: false
    }
  }
}
