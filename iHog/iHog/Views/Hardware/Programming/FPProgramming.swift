//
//  FPProgramming.swift
//  iHog
//
//  Created by Maegan Wilson on 9/23/20.
//

import SwiftUI

struct RegRegFPProgramming: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack{
            Text("Horizontal \(horizontalSizeClass.debugDescription) \n Vertical: \(verticalSizeClass.debugDescription)")
            EncoderWheelsView()
            HStack(alignment: .bottom){
                VStack{
                    ObjectButtonView()
                    Spacer()
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 100, minHeight: 0, idealHeight: 72, maxHeight: 72, alignment: .center)
                    ActionButtonView()
                    Spacer()
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 100, minHeight: 0, idealHeight: 80, maxHeight: 80, alignment: .center)
                    UtilityButtonView()
                }
                VStack{
                    KindButtonView()
                    Spacer()
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 100, minHeight: 0, idealHeight: 72, maxHeight: 72, alignment: .center)
                    NumericKeypadView()
                }
                    .padding(.horizontal)
                VStack(alignment: .leading){
                    HStack{
                        FPButton(buttonText: "Blind")
                        FPButton(buttonText: "High Light")
                        FPButton(buttonText: "Clear")
                    }
                    Spacer()
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 100, minHeight: 0, idealHeight: 80, maxHeight: 80, alignment: .center)
                    HStack{
                        FPButton(buttonText: "Back")
                        FPButton(buttonText: "All")
                        FPButton(buttonText: "Next")
                    }
                    Spacer()
                        .frame(minWidth: 100, idealWidth: 100, maxWidth: 100, minHeight: 0, idealHeight: 72, maxHeight: 72, alignment: .center)
                    FunctionKeyView()
                }
            }
        }
    }
}

struct FPProgramming_Previews: PreviewProvider {
    static var previews: some View {
        RegRegFPProgramming()
            
    }
}
