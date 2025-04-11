//
//  EncodeWheelsView.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import SwiftUI

struct EncoderWheelsView: View {
  @EnvironmentObject var osc: OSCHelper
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  @AppStorage(AppStorageKey.isNanoModeOn.rawValue) var isNanoModeOn: Bool = false
  @AppStorage(AppStorageKey.encoderWheelPrecision.rawValue) var encoderWheelPrecision: Double = 2.0
  @AppStorage(AppStorageKey.isEncoderFine.rawValue) var isEncoderFine: Bool = false

  var body: some View {
    switch horizontalSizeClass {
      case .regular:
        // ipad or room for 5 encoders
        switch verticalSizeClass {
          case .regular:
            HStack(spacing: 30) {
              GroupBox {
                Toggle("Fine Control", isOn: $isEncoderFine)
              }
              .frame(width: 200)
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
          default:
            VStack(alignment: .leading) {
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

              GroupBox {
                Toggle("Fine Control", isOn: $isEncoderFine)
              }
            }
            .fixedSize(horizontal: true, vertical: false)
        }
      default:
        VStack(alignment: .leading) {
          GroupBox {
            Toggle("Fine Control", isOn: $isEncoderFine)
          }
          .frame(width: 200)
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
  }
}

struct EncoderWheelsView_Previews: PreviewProvider {
  static var previews: some View {
    EncoderWheelsView()
  }
}
