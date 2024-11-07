//
//  IntroToiHogView.swift
//  iHog
//
//  Created by Jay Wilson on 2/14/22.
//

import SwiftUI

struct IntroToiHogView: View {

    @Binding var currentStep: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Thanks for downloading iHog. Here are some features", comment: "Short tag line for iHog. Only seen in the onboarding screen")
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 20) {
                    Image(systemName: "paintpalette")
                        .foregroundColor(.green)
                        .frame(width: 50)
                    Text("Use your palettes and groups")
                }
                HStack(spacing: 20) {
                    Image(systemName: "play")
                        .foregroundColor(.green)
                        .frame(width: 50)
                    Text("Go lists and scenes")
                }
                HStack(spacing: 20) {
                    Image(systemName: "slider.horizontal.below.square.filled.and.square")
                        .foregroundColor(.green)
                        .frame(width: 50)
                    Text("Use the console's hardware")
                }
                HStack(spacing: 20) {
                    Image(systemName: "icloud.and.arrow.up")
                        .foregroundColor(.green)

                        .frame(width: 50)
                    Text("Sync between devices")
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Connect to console") {
                    currentStep += 1
                }.padding()
                    .foregroundColor(.white)
                    .background(RoundedRectangle(cornerRadius: 10.0)
                                    .fill(Color.blue))

                Spacer()
            }
        }.font(.body)
            .padding(.horizontal)
    }
}

struct IntroToiHogView_Previews: PreviewProvider {
    @State static var currentStep = 1
    static var previews: some View {
        IntroToiHogView(currentStep: $currentStep)
    }
}
