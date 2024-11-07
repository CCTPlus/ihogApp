//
//  FunctionKeyView.swift
//  iHog
//
//  Created by Jay Wilson on 9/25/20.
//

import SwiftUI

struct FunctionKeyView: View {
    @EnvironmentObject var osc: OSCHelper
    
    var body: some View {
        VStack(spacing: 1){
            HStack(spacing: 1){
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h1.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h1.rawValue]![1],
                    buttonFunction: .h1
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h2.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h2.rawValue]![1],
                    buttonFunction: .h2
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h3.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h3.rawValue]![1],
                    buttonFunction: .h3
                )
            }
            HStack(spacing: 1){
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h4.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h4.rawValue]![1],
                    buttonFunction: .h4
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h5.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h5.rawValue]![1],
                    buttonFunction: .h5
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h6.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h6.rawValue]![1],
                    buttonFunction: .h6
                )
            }
            HStack(spacing: 1){
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h7.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h7.rawValue]![1],
                    buttonFunction: .h7
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h8.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h8.rawValue]![1],
                    buttonFunction: .h8
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h9.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h9.rawValue]![1],
                    buttonFunction: .h9
                )
            }
            HStack(spacing: 1){
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h10.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h10.rawValue]![1],
                    buttonFunction: .h10
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h11.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h11.rawValue]![1],
                    buttonFunction: .h11
                )
                FPButton(
                    buttonText: osc.functionKeys[ButtonFunctionNames.h12.rawValue]![0] + "\n"
                              + osc.functionKeys[ButtonFunctionNames.h12.rawValue]![1],
                    buttonFunction: .h12
                )
            }
        }
        .padding(.bottom)
    }
}

struct FunctionKeyView_Previews: PreviewProvider {
    static var previews: some View {
        FunctionKeyView()
    }
}
