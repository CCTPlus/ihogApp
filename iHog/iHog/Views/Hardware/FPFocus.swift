//
//  FPFocus.swift
//  iHog
//
//  Created by Jay Wilson on 11/5/21.
//

import SwiftUI

struct FPFocus: View {
  @EnvironmentObject var osc: OSCHelper
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  @AppStorage(AppStorageKey.isNanoModeOn.rawValue) var isNanoModeOn: Bool = false

  var body: some View {
    switch horizontalSizeClass {
      case .regular:
        HStack {
          SelectButtonView()
          NumericKeypadView()
          VStack {
            HStack {
              EncoderWheel(
                encoderWheelNum: 1,
                paramName: osc.encoderWheelLabels[0],
                paramValue: osc.encoderWheelValues[0]
              )
              EncoderWheel(
                encoderWheelNum: 2,
                paramName: osc.encoderWheelLabels[1],
                paramValue: osc.encoderWheelValues[1]
              )
              EncoderWheel(
                encoderWheelNum: 3,
                paramName: osc.encoderWheelLabels[2],
                paramValue: osc.encoderWheelValues[2]
              )
            }
            HStack {
              EncoderWheel(
                encoderWheelNum: 4,
                paramName: osc.encoderWheelLabels[3],
                paramValue: osc.encoderWheelValues[3]
              )
              if isNanoModeOn == false {
                EncoderWheel(
                  encoderWheelNum: 5,
                  paramName: osc.encoderWheelLabels[4],
                  paramValue: osc.encoderWheelValues[4]
                )
              }
            }
          }
        }
        .padding()
        .navigationTitle(osc.commandLine)
        .navigationBarTitleDisplayMode(.inline)
      default:
        switch verticalSizeClass {
          case .regular:
            VStack {
              SelectButtonView()
              NumericKeypadView()
              HStack {
                EncoderWheel(
                  encoderWheelNum: 1,
                  paramName: osc.encoderWheelLabels[0],
                  paramValue: osc.encoderWheelValues[0]
                )
                EncoderWheel(
                  encoderWheelNum: 2,
                  paramName: osc.encoderWheelLabels[1],
                  paramValue: osc.encoderWheelValues[1]
                )
                EncoderWheel(
                  encoderWheelNum: 3,
                  paramName: osc.encoderWheelLabels[2],
                  paramValue: osc.encoderWheelValues[2]
                )
              }
              HStack {
                EncoderWheel(
                  encoderWheelNum: 4,
                  paramName: osc.encoderWheelLabels[3],
                  paramValue: osc.encoderWheelValues[3]
                )
                if isNanoModeOn == false {
                  EncoderWheel(
                    encoderWheelNum: 5,
                    paramName: osc.encoderWheelLabels[4],
                    paramValue: osc.encoderWheelValues[4]
                  )
                }
              }
            }
            .padding()
            .navigationTitle(osc.commandLine)
            .navigationBarTitleDisplayMode(.inline)
          default:
            HStack {
              VStack {
                HStack {
                  Button("<-") {
                    pushButton(buttonFunction: .backspace)
                    releaseButton(buttonFunction: .backspace)
                    print("Backspace")
                  }
                  .buttonStyle(
                    FrontPanelButton(width: 65, height: 65 * 1.25, backgroundColor: .gray)
                  )
                  VStack {
                    Button("-") {
                      print("Minus")
                    }
                    .buttonStyle(
                      FrontPanelButton(width: 65, height: (65 / 2), backgroundColor: .gray)
                    )
                    .pressActions {
                      print("Pressed")
                      pushButton(buttonFunction: .minus)
                    } onRelease: {
                      releaseButton(buttonFunction: .minus)
                    }
                    Button("/") {
                      print("Slash")
                    }
                    .buttonStyle(
                      FrontPanelButton(width: 65, height: (65 / 2), backgroundColor: .gray)
                    )
                    .pressActions {
                      print("Pressed")
                      pushButton(buttonFunction: .slash)
                    } onRelease: {
                      releaseButton(buttonFunction: .slash)
                    }
                  }
                  VStack {
                    Button("+") {
                      print("Plus")
                    }
                    .buttonStyle(
                      FrontPanelButton(width: 65, height: (65 / 2), backgroundColor: .gray)
                    )
                    .pressActions {
                      print("Pressed")
                      pushButton(buttonFunction: .plus)
                    } onRelease: {
                      releaseButton(buttonFunction: .plus)
                    }
                    Button("Full") {
                      print("Full")
                    }
                    .buttonStyle(
                      FrontPanelButton(width: 65, height: (65 / 2), backgroundColor: .gray)
                    )
                    .pressActions {
                      print("Pressed")
                      pushButton(buttonFunction: .full)
                    } onRelease: {
                      releaseButton(buttonFunction: .full)
                    }
                  }
                  VStack {
                    Button("Thru") {
                      print("Thru")
                    }
                    .buttonStyle(
                      FrontPanelButton(width: 65, height: (65 / 2), backgroundColor: .gray)
                    )
                    .pressActions {
                      print("Pressed")
                      pushButton(buttonFunction: .thru)
                    } onRelease: {
                      releaseButton(buttonFunction: .thru)
                    }
                    Button("@") {
                      print("@")
                    }
                    .buttonStyle(
                      FrontPanelButton(width: 65, height: (65 / 2), backgroundColor: .gray)
                    )
                    .pressActions {
                      print("Pressed")
                      pushButton(buttonFunction: .at)
                    } onRelease: {
                      releaseButton(buttonFunction: .at)
                    }
                  }
                }
                SelectButtonView()
              }
              NumericKeypadView()
              VStack {
                HStack {
                  EncoderWheel(
                    encoderWheelNum: 1,
                    paramName: osc.encoderWheelLabels[0],
                    paramValue: osc.encoderWheelValues[0]
                  )
                  EncoderWheel(
                    encoderWheelNum: 2,
                    paramName: osc.encoderWheelLabels[1],
                    paramValue: osc.encoderWheelValues[1]
                  )
                  EncoderWheel(
                    encoderWheelNum: 3,
                    paramName: osc.encoderWheelLabels[2],
                    paramValue: osc.encoderWheelValues[2]
                  )
                }
                HStack {
                  EncoderWheel(
                    encoderWheelNum: 4,
                    paramName: osc.encoderWheelLabels[3],
                    paramValue: osc.encoderWheelValues[3]
                  )
                  if isNanoModeOn == false {
                    EncoderWheel(
                      encoderWheelNum: 5,
                      paramName: osc.encoderWheelLabels[4],
                      paramValue: osc.encoderWheelValues[4]
                    )
                  }
                }
              }
            }
            .padding()
            .navigationTitle(osc.commandLine)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
  }

  // MARK: Used for all buttons not a number key
  func pushButton(buttonFunction: ButtonFunctionNames) {
    osc.pushFrontPanelButton(button: buttonFunction.rawValue)
  }

  // MARK: Only used for number keys
  func pushButton(number: String) {
    osc.pushFrontPanelButton(button: number)
  }

  // MARK: RELEASE BUTTONS

  func releaseButton(buttonFunction: ButtonFunctionNames) {
    osc.releaseFrontPanelButton(button: buttonFunction.rawValue)
  }

  // MARK: Only used for number keys
  func releaseButton(number: String) {
    osc.releaseFrontPanelButton(button: number)
  }
}

struct FPFocus_Previews: PreviewProvider {
  static var previews: some View {
    FPFocus()
  }
}
