//
//  OBProgressView.swift
//  iHog
//
//  Created by Jay Wilson on 2/14/22.
//

import SwiftUI

struct OBProgressView: View {
    let steps = [1, 2, 3]
    var currentStep = 1
    var body: some View {
        HStack(spacing: 40) {
            ForEach(steps, id: \.self) { step in
                if(step < currentStep) {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                } else {
                    Image(systemName: "circle")
                        .font(.largeTitle)
                }
            }.opacity(0.5)
        }.frame(height: 40).animation(.easeInOut, value: currentStep)
    }
}

struct OBProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            OBProgressView(currentStep: 4)
        }
    }
}
