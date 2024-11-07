//
//  ShowObjectGridView.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import SwiftUI

struct ShowObjectGridView: View {
    @Environment(ShowRouter.self) var showRouter
    var newObjectType: ObjectType? = nil
    var objects: [ShowObjectEntity]
    var size: CGSize
    
    let columns: [GridItem]
    
    init(
        objects: [ShowObjectEntity],
        newObjectType: ObjectType? = nil,
        size: CGSize,
        columns: [GridItem] = GridConstant.objectGrid(width: 100)
    ) {
        self.newObjectType = newObjectType
        self.objects = objects
        self.size = size
        self.columns = GridConstant.objectGrid(width: size.width)
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(objects, id: \.id) { obj in
                ShowObjectView(showObject: obj, size: size)
            }
            if let newObjectType {
                Button {
                    showRouter.show(sheet: .newObject)
                } label: {
                    VStack(spacing: 4) {
                        Spacer()
                            Image(systemName: "plus")
                            Text("New \(newObjectType.rawValue.capitalized)")
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview("New object") {
    ShowObjectGridView(objects: ShowObjectEntity.mock(with: 5), newObjectType: .list, size: CGSize(width: 80, height: 80))
        .environment(OSCManager.mock)
        .environment(ShowRouter())
}

#Preview("No new object") {
    ShowObjectGridView(objects: ShowObjectEntity.mock(with: 5), size: CGSize(width: 80, height: 80))
        .environment(OSCManager.mock)
        .environment(ShowRouter())
}
