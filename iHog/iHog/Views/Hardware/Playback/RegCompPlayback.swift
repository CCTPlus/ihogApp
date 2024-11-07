//
//  RegCompPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 11/19/20.
//

import SwiftUI

struct RegCompPlayback: View {
    @EnvironmentObject var osc: OSCHelper
    var body: some View {
        HStack{
            VStack{
                FPButton(buttonText: "CH", buttonFunction: .mainchoose)
                    .padding(.bottom)
                Spacer().frame(height: BASE_BUTTON_SIZE)
                    .padding(HALF_PADDING)
                FPButton(buttonText: "A", buttonFunction: .assert)
                    .padding(.bottom)
                FPButton(buttonText: "R", buttonFunction: .release)
                    .contextMenu{
                        Button(action: {
                            osc.sendReleaseAllMessage()
                        }, label: {
                            Text("Release All")
                        })
                    }
            }
            VStack{
                FPButton(buttonText: "Next Page", buttonFunction: .nextpage)
                FPButton(buttonText: "Back Page", buttonFunction: .backpage)
                FPButton(buttonText: ">>", buttonFunction: .skipfwd)
                    .padding(.vertical)
                FPButton(buttonText: "<<", buttonFunction: .skipback)
            }
            .padding()
            VStack{
                FPButton(buttonText: "Back", buttonFunction: .mainback)
                    .padding(.bottom)
                FPButton(buttonText: "Pause", buttonFunction: .mainhalt)
                    .padding(.bottom)
                Spacer().frame(height: BASE_BUTTON_SIZE)
                    .padding(HALF_PADDING)
                FPButton(buttonText: "Play", buttonFunction: .maingo)
            }
            ScrollView(.vertical){
                LazyVStack{
                    ForEach(1 ..< 90) { num in
                        HorizontalMasterView(masterNumber: num).padding(.all, BASE_PADDING)
                    }
                }
            }.padding(.horizontal)
        }
    }
}

struct RegCompPlayback_Previews: PreviewProvider {
    static var previews: some View {
        RegCompPlayback()
    }
}
