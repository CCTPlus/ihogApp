//
//  AppStorageKey.swift
//  iHog
//
//  Created by Jay Wilson on 12/5/24.
//

enum AppStorageKey: String {
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
}
