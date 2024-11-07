//
//  SelectButtonView.swift
//  iHog
//
//  Created by Jay Wilson on 9/25/20.
//

import SwiftUI

struct SelectButtonView: View {
    @EnvironmentObject var osc: OSCHelper
    
    var body: some View {
        HStack(spacing: 1){
            Button("Back"){print("back")}
            .pressActions {
                pushButton(buttonFunction: .back)
            } onRelease: {
                releaseButton(buttonFunction: .back)
            }
            .buttonStyle(FrontPanelButton(width: 65, backgroundColor: .gray))
            
            Button("All"){print("all")}.pressActions {
                pushButton(buttonFunction: .all)
            } onRelease: {
                releaseButton(buttonFunction: .all)
            }
            .buttonStyle(FrontPanelButton(width: 65, backgroundColor: .gray))
            
            Button("Next"){print("next")}.pressActions {
                pushButton(buttonFunction: .next)
            } onRelease: {
                releaseButton(buttonFunction: .next)
            }
            .buttonStyle(FrontPanelButton(width: 65, backgroundColor: .gray))
        }
    }
    // MARK: Used for all buttons not a number key
    func pushButton(buttonFunction: ButtonFunctionNames){
        osc.pushFrontPanelButton(button: buttonFunction.rawValue)
    }
    
    // MARK: RELEASE BUTTONS
    
    func releaseButton(buttonFunction: ButtonFunctionNames){
        osc.releaseFrontPanelButton(button: buttonFunction.rawValue)
    }
}

struct SelectButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SelectButtonView()
    }
}
