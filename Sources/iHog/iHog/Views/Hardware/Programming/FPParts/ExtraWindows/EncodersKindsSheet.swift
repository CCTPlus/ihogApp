//
//  EncodersKindsSheet.swift
//  iHog
//
//  Created by Jay Wilson on 9/28/20.
//

import SwiftUI

struct EncodersKindsSheet: View {
  /** OSC Info*/
  @EnvironmentObject var osc: OSCHelper

  /** Used to determine rotation */
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  /** Used to determine when the sheet is dismissed*/
  @Environment(\.dismiss) var dismiss
  var body: some View {
    switch horizontalSizeClass {
      case .regular:
        VStack {
          switch verticalSizeClass {
            case .regular:
              // Close button
              CloseButton()
              //            Spacer()
              EncoderWheelsView().environmentObject(osc)
              Spacer()
              KindButtonView().environmentObject(osc)
              Spacer()
            default:
              VStack {
                // Close button
                CloseButton()
                Spacer()
                HStack {
                  EncoderWheelsView().environmentObject(osc)
                  Spacer()
                  KindButtonView().environmentObject(osc)
                  Spacer()
                }
              }
          }
        }
      // Compact size class
      default:
        VStack {  // Close button
          CloseButton()
          Spacer()
          switch verticalSizeClass {
            case .regular:
              VStack {
                Spacer()
                KindButtonView().environmentObject(osc)
                Spacer()
                EncoderWheelsView().environmentObject(osc)
                  .padding(.bottom, BASE_PADDING * 4)
              }
            default:
              HStack {
                EncoderWheelsView().environmentObject(osc)
                Spacer()
                KindButtonView().environmentObject(osc)
                Spacer()
              }
          }
        }
    }
  }
}

struct EncodersKindsSheet_Previews: PreviewProvider {
  static var previews: some View {
    EncodersKindsSheet()
  }
}
