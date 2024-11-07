//
//  UtilityButtonView.swift
//  iHog
//
//  Created by Jay Wilson on 9/24/20.
//

import SwiftUI

struct UtilityButtonView: View {
    var body: some View {
        VStack(spacing: 1){
            HStack(spacing: 1){
                FPButton(buttonText: "Setup", buttonFunction: ButtonFunctionNames.setup)
                FPButton(buttonText: "Goto", buttonFunction: ButtonFunctionNames.goto)
                FPButton(buttonText: "Set", buttonFunction: ButtonFunctionNames.set)
            }
            HStack(spacing: 1){
                FPButton(buttonText: "Pig", buttonFunction: ButtonFunctionNames.pig)
                FPButton(buttonText: "Fan", buttonFunction: ButtonFunctionNames.fan)
                FPButton(buttonText: "Open", buttonFunction: ButtonFunctionNames.open)
            }
        }
    }
}

struct UtilityButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UtilityButtonView()
    }
}
