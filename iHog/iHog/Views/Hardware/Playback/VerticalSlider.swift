//
//  VerticalSlider.swift
//  iHog
//
//  Created by Jay Wilson on 9/30/20.
//

import SwiftUI

// +y value for offset = up
// -y value for offset = down
struct VerticalSlider: View {
    @EnvironmentObject var osc: OSCHelper
    @State private var faderLevel: Double = 110
    @State private var consoleFaderValue: Double = 0.0
    @State private var absoluteFaderLevel: Double = 0.0
    
    var master: Int
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: BASE_CORNER_RADIUS)
                .fill(Color.gray)
                .frame(width: BASE_SLIDER_WIDTH,
                    height: BASE_SLIDER_HEIGHT,
                    alignment: .center
                )
            RoundedRectangle(cornerRadius: BASE_CORNER_RADIUS)
                .frame(width: BASE_THUMB_SIZE,
                       height: BASE_THUMB_SIZE,
                       alignment: .center)
                .offset(y: CGFloat(-(osc.faders[master])))
                .gesture(DragGesture()
                            .onChanged({value in
                                setFaderLevel(newValue: value.location.y)
                            })
                            .onEnded({ value in
                                setIncomingFaderLevel()
                            }))
        }
    }
    
    func setFaderLevel(newValue: CGFloat) {
        // 110 is min
        //-110 is max
        if newValue >= 110 {
            absoluteFaderLevel = 0
            faderLevel = 110
            consoleFaderValue = 0
        } else if newValue <= -110 {
            absoluteFaderLevel = 220
            faderLevel = -110
            consoleFaderValue = 255
        } else if Double(newValue) < faderLevel {
            // Fader moves up
            absoluteFaderLevel = absoluteFaderLevel + (faderLevel-Double(newValue))
            faderLevel = Double(newValue)
            consoleFaderValue = absoluteFaderLevel * 1.159
        } else if Double(newValue) > faderLevel {
            // Fader moves down
            absoluteFaderLevel = absoluteFaderLevel - abs(faderLevel-Double(newValue))
            faderLevel = Double(newValue)
            consoleFaderValue = absoluteFaderLevel * 1.159
        }
        osc.sendFaderValue(master: master, value: Float(consoleFaderValue))
        osc.setFaderLevel(value: Float(consoleFaderValue), fader: master)
    }
    
    func setIncomingFaderLevel() {
        faderLevel = Double(osc.faders[master])
    }
}

struct VerticalSlider_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSlider(master: 0)
    }
}
