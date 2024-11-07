//
//  PPPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 2/4/21.
//

import SwiftUI
import CoreData

struct PPPlayback: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @AppStorage(Settings.chosenShowID.rawValue) var chosenShowID: String = ""
//    @State private var show.playbackObjects: [ShowObject] = []
    @State private var mainPlaybackIsShowing = false
    
    @ObservedObject var show: ChosenShow
    
    var body: some View {
        if horizontalSizeClass == .regular {
            if verticalSizeClass == .regular {
                HStack{
                    CompPlayback()
                    ObjectGrid(size: "medium",
                               buttonsAcross: 3,
                               objects: show.playbackObjects,
                               show: show)
                }.onAppear{
                    getAllObjects()
                }
            } else {
                HStack{
                    CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
                    if mainPlaybackIsShowing == false {
                        ObjectGrid(size: "medium",
                                   buttonsAcross: 3,
                                   objects: show.playbackObjects,
                                   show: show)
                            .transition(.move(edge: .bottom))
                    } else {
                        VertMainPlaybacks()
                            .transition(.move(edge: .bottom))
                    }
                }.onAppear{
                    getAllObjects()
                }
                
            }
        } else {
            if verticalSizeClass == .regular {
                VStack{
                    CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
                    if mainPlaybackIsShowing == false {
                        ObjectGrid(size: "medium",
                                   buttonsAcross: 3,
                                   objects: show.playbackObjects,
                                   show: show)
                            .transition(.move(edge: .bottom))
                    } else {
                        VertMainPlaybacks()
                            .transition(.move(edge: .bottom))
                    }
                }.onAppear{
                    getAllObjects()
                }
            } else {
                HStack{
                    CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
                    if mainPlaybackIsShowing == false {
                        ObjectGrid(size: "medium",
                                   buttonsAcross: 3,
                                   objects: show.playbackObjects,
                                   show: show)
                            .transition(.move(edge: .bottom))
                    } else {
                        VertMainPlaybacks()
                            .transition(.move(edge: .bottom))
                    }
                }.onAppear{
                    getAllObjects()
                }
            }
        }
    }
    
    func getAllObjects(){
        show.lists = []
        show.scenes = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowObjectEntity")
        fetchRequest.predicate = NSPredicate(format: "showID == %@", chosenShowID)
        
        do {
            let results = try viewContext.fetch(fetchRequest) as! [ShowObjectEntity]
            for showObj in results{
                switch showObj.objType {
                case ShowObjectType.list.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .list,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "gray",
                        isOutlined: showObj.isOutlined
                    )
                    show.addList(newObj)
                case ShowObjectType.scene.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .scene,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "green",
                        isOutlined: showObj.isOutlined
                    )
                    show.addScene(newObj)
                default:
                    continue
                }
            }
            show.lists.sort(by: {$0.number < $1.number})
            show.scenes.sort(by: {$0.number < $1.number})
        } catch {
            print(error)
        }
    }
}
//struct PPPlayback_Previews: PreviewProvider {
//    static var previews: some View {
//        PPPlayback()
//    }
//}
