//
//  About.swift
//  iHog
//
//  Created by Jay Wilson on 2/20/21.
//

import SwiftUI

struct About: View {
    @Binding var selectedSetting: SettingsNav?
    @Binding var issueSubmitted: Bool?
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    @State private var tip = ""
    
    var body: some View {
        Section(header: Text("About"),
                footer: Text("App Version: \(appVersion ?? "N/A") (\(appBuild ?? "N/A"))")){
            Link("\(Image(systemName: "info.circle")) About [iHog Website]", destination: URL(string: "https://ihogapp.com/about")!)
            Link("\(Image(systemName: "bubble.left")) Chat about iHog [Dev's discord link]", destination: URL(string: "https://discord.gg/HmGYbNHmun")!)
        }.headerProminence(.increased)
    }
}

//struct About_Previews: PreviewProvider {
//    static var previews: some View {
//        About()
//    }
//}
