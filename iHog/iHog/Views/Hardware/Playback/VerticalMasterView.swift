//
//  MasterView.swift
//  iHog
//
//  Created by Jay Wilson on 9/30/20.
//

import SwiftUI

struct VerticalMasterView: View {
    @EnvironmentObject var osc: OSCHelper

    var masterNumber: Int
    
    var body: some View {
        VStack{
            FPButton(buttonText: "\(masterNumber)",
                     buttonFunction: .choose,
                     buttonNumber: masterNumber,
                     bgColor: osc.chooses[masterNumber])
            FPButton(buttonText: "Play",
                     buttonFunction: .go,
                     buttonNumber: masterNumber,
                     bgColor: osc.plays[masterNumber])
            FPButton(buttonText: "Pause",
                     buttonFunction: .pause,
                     buttonNumber: masterNumber,
                     bgColor: osc.pauses[masterNumber])
            FPButton(buttonText: "Back",
                     buttonFunction: .goback,
                     buttonNumber: masterNumber,
                     bgColor: osc.backs[masterNumber])
            VerticalSlider(master: masterNumber)
            FPButton(buttonText: "FLASH",
                     buttonFunction: .flash,
                     buttonNumber: masterNumber,
                     bgColor: osc.flashes[masterNumber])
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalMasterView(masterNumber: 1)
    }
}
