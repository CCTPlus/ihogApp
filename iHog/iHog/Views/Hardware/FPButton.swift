//
//  FPButton.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import SwiftUI

/// Front panel button
struct FPButton: View {
    @EnvironmentObject var osc: OSCHelper
    
    var buttonText: String
    var buttonFunction: ButtonFunctionNames
    var buttonNumber: Int = 0
    var size: Int = 1

    var bgColor: Color = Color.gray
    
    var body: some View {
        Button(buttonText){
            print("\(buttonText) pressed Function = \(buttonFunction.rawValue)")
        }
        .pressActions{
            pushButton()
        } onRelease: {
            releaseButton()
        }
        .buttonStyle(
            FrontPanelButton(
                width: setSize(),
                backgroundColor: bgColor)
        )
    }
    
    func color(for button: Float) -> Color {
        button == 0.0 ? .gray : .blue
    }
    
    func setSize() -> CGFloat {
        switch size {
        case 0:
            return SMALL_BUTTON_SIZE
        case 1:
            return BASE_BUTTON_SIZE
        case 3:
            return L_BUTTON_WIDTH
        default:
            return BASE_BUTTON_SIZE
        }
    }
    
    func pushButton(){
        switch buttonFunction {
        case ButtonFunctionNames.choose,
             ButtonFunctionNames.goback,
             ButtonFunctionNames.pause,
             ButtonFunctionNames.go,
             ButtonFunctionNames.flash:
            osc.pushPlaybackButton(button: buttonFunction.rawValue, master: buttonNumber)
        case ButtonFunctionNames.numberpad:
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            let english = formatter.string(from: NSNumber(value: buttonNumber))
            osc.pushFrontPanelButton(button: english!)
        default:
            osc.pushFrontPanelButton(button: buttonFunction.rawValue)
        }
    }
    
    func releaseButton(){
        switch buttonFunction {
        case ButtonFunctionNames.choose,
             ButtonFunctionNames.goback,
             ButtonFunctionNames.pause,
             ButtonFunctionNames.go,
             ButtonFunctionNames.flash:
            osc.releasePlaybackButton(button: buttonFunction.rawValue, master: buttonNumber)
        case ButtonFunctionNames.numberpad:
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            let english = formatter.string(from: NSNumber(value: buttonNumber))
            osc.releaseFrontPanelButton(button: english!)
        default:
            osc.releaseFrontPanelButton(button: buttonFunction.rawValue)
        }
    }
}

//struct FPButton_Previews: PreviewProvider {
//    static var previews: some View {
//        FPButton(
//            buttonText: "Record",
//            buttonFunction: .record
//        )
//    }
//}
