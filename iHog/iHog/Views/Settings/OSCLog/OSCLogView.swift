//
//  OSCLogView.swift
//  iHog
//
//  Created by Jay Wilson on 2/23/21.
//

import SwiftUI

struct OSCLogView: View {
    @EnvironmentObject var osc: OSCHelper
    @State private var logIsPaused = false
    
    var body: some View {
        VStack{
            Toggle(isOn: $osc.isLogPaused){
                Text(osc.isLogPaused ? "Resume OSC Log" : "Pause OSC Log")
            }.onChange(of: logIsPaused){ newValue in
                    osc.toggleLog(logIsPaused)
                }
                .padding(.horizontal)
            List{
                ForEach(osc.oscLog.reversed(), id: \.self) { message in
                    HStack{
                        if message["sent"] == "no" {
                            Image(systemName: "arrow.down.square")
                                .padding(.horizontal)
                                .foregroundColor(.orange)
                        } else {
                            Image(systemName: "arrow.up.square")
                                .padding(.horizontal)
                                .foregroundColor(.purple)
                        }
                        Text(message["message"] ?? "NO MESSAGE")
                        Spacer()
                        Text(message["argument"] ?? "NO MESSAGE")
                    }
                }
            }
        }
    }
}

struct OSCLogView_Previews: PreviewProvider {
    static var previews: some View {
        OSCLogView()
    }
}
