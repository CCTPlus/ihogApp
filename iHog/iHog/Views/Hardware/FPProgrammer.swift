//
//  FPProgrammer.swift
//  iHog
//
//  Created by Jay Wilson on 9/25/20.
//

import SwiftUI

struct FPProgrammer: View {
    @EnvironmentObject var osc: OSCHelper
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        switch horizontalSizeClass {
        case .regular:
            if verticalSizeClass == .regular {
                RegRegFPProgramming()
                    .navigationTitle(osc.commandLine)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                RegCompFPProgramming()
                    .navigationTitle(osc.commandLine)
                    .navigationBarTitleDisplayMode(.inline)
            }
        default: // compact
            // iPhones and iPods usually this one
            if verticalSizeClass == .regular {
                CompRegFPprogramming()
                    .navigationTitle(osc.commandLine)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                RegCompFPProgramming()
                    .navigationTitle(osc.commandLine)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct FPProgrammer_Previews: PreviewProvider {
    static var previews: some View {
        FPProgrammer()
    }
}
