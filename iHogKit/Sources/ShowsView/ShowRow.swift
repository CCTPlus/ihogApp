// SwiftUIView.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import SwiftUI
import ShowsCore

struct ShowRow: View {
    var show: Show
    var deleteAction: () -> Void
    var launchShowAction: () -> Void
    init(_ show: Show, _ deleteAction: @escaping () -> Void, _ launchShowAction: @escaping () -> Void) {
        self.show = show
        self.deleteAction = deleteAction
        self.launchShowAction = launchShowAction
    }
    var body: some View {
        HStack {
            Text(show.name)
            Spacer()
            Button { deleteAction() } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    List {
        Section {
            ShowRow(.mock, { print("Delete Action") }, { print("Launch action") })
        }
    }
}
