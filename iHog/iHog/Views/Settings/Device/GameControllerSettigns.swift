//
//  GameControllerSettigns.swift
//  iHog
//
//  Created by Jay Wilson on 3/24/21.
//

import SwiftUI
import GameController

struct GameControllerSettigns: View {
    @State private var isConntected = false
    @State private var controllers: [Any] = []
    var gameController = GCController()
    
    var body: some View {
        Section(header: Text("Game Controller Options")) {
            HStack{
                Text("Connect for game controller")
                Button("Connect") {
                    print("Will CONNECT")
                    GCController.startWirelessControllerDiscovery {
                        print("Did start")
                    }
                }
            }
        }
    }
}

struct GameControllerSettigns_Previews: PreviewProvider {
    static var previews: some View {
        GameControllerSettigns()
    }
}
