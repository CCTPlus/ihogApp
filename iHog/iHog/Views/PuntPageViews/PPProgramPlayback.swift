//
//  PPProgramPlayback.swift
//  iHog
//
//  Created by Jay Wilson on 2/6/21.
//

import SwiftUI
import CoreData

struct PPProgramPlayback: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @AppStorage(Settings.chosenShowID.rawValue) var chosenShowID: String = ""
    
//    @State private var show.groups: [ShowObject] = []
//    @State private var show.palettes: [ShowObject] = []
    
    @State private var mainPlaybackIsShowing = false
    
    @State private var chosenPaletteType = 0
    
    @ObservedObject var show: ChosenShow
    
    let paletteTypes: [ShowObjectType] = [.intensity, .position, .color, .beam, .effect]
    
    var body: some View {
        if horizontalSizeClass == .regular {
            if verticalSizeClass == .regular {
                HStack{
                    CompPlayback()
                    VStack{
                        ObjectGrid(size: "medium",
                                   buttonsAcross: 3,
                                   objects: show.groups,
                                   show: show)
                        Picker("palette selection", selection: $chosenPaletteType) {
                            ForEach(0 ..< paletteTypes.count, id: \.self) {
                                Text(paletteTypes[$0].rawValue.capitalized)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        ObjectGrid(
                            size: "medium",
                            buttonsAcross: 3,
                            objects: show.palettes.filter({ obj in
                                return obj.objType == paletteTypes[chosenPaletteType]
                            }),
                            show: show
                        )
                        
                    }
                }.onAppear{
                    getAllObjects()
                }
            } else {
                HStack{
                    CompactFaders(mainPlaybackIsShowing: $mainPlaybackIsShowing)
                    if mainPlaybackIsShowing == false {
                        VStack{
                            ObjectGrid(size: "medium",
                                       buttonsAcross: 3,
                                       objects: show.groups,
                                       show: show)
                                .transition(.move(edge: .bottom))
                            
                            VStack{
                                ObjectGrid(size: "medium",
                                           buttonsAcross: 3,
                                           objects: show.groups,
                                           show: show)
                                Picker("palette selection", selection: $chosenPaletteType) {
                                    ForEach(0 ..< paletteTypes.count, id: \.self) {
                                        Text(paletteTypes[$0].rawValue.capitalized)
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                ObjectGrid(
                                    size: "medium",
                                    buttonsAcross: 3,
                                    objects: show.palettes.filter({ obj in
                                        return obj.objType == paletteTypes[chosenPaletteType]
                                    }),
                                    show: show
                                )
                                
                            }
                        }
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
                            VStack{
                                ObjectGrid(size: "small",
                                           buttonsAcross: 3,
                                           objects: show.groups,
                                           show: show)
                                Picker("palette selection", selection: $chosenPaletteType) {
                                    ForEach(0 ..< paletteTypes.count, id: \.self) {
                                        Text(paletteTypes[$0].rawValue.capitalized)
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                ObjectGrid(
                                    size: "small",
                                    buttonsAcross: 3,
                                    objects: show.palettes.filter({ obj in
                                        return obj.objType == paletteTypes[chosenPaletteType]
                                    }),
                                    show: show
                                )
                                
                            }
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
                            VStack{
                                ObjectGrid(size: "small",
                                           buttonsAcross: 3,
                                           objects: show.groups,
                                           show: show)
                                Picker("palette selection", selection: $chosenPaletteType) {
                                    ForEach(0 ..< paletteTypes.count, id: \.self) {
                                        Text(paletteTypes[$0].rawValue.capitalized)
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                ObjectGrid(
                                    size: "small",
                                    buttonsAcross: 3,
                                    objects: show.palettes.filter({ obj in
                                        return obj.objType == paletteTypes[chosenPaletteType]
                                    }),
                                    show: show
                                )
                                
                            }
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
        show.groups = []
        show.palettes = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowObjectEntity")
        fetchRequest.predicate = NSPredicate(format: "showID == %@", chosenShowID)
        
        do {
            let results = try viewContext.fetch(fetchRequest) as! [ShowObjectEntity]
            for showObj in results{
                switch showObj.objType {
                case ShowObjectType.group.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .group,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "red",
                        isOutlined: showObj.isOutlined
                    )
                    show.addGroup(newObj)
                case ShowObjectType.intensity.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .intensity,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "blue",
                        isOutlined: showObj.isOutlined
                    )
                    show.addPalette(newObj)
                case ShowObjectType.position.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .position,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "blue",
                        isOutlined: showObj.isOutlined
                    )
                    show.addPalette(newObj)
                case ShowObjectType.color.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .color,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "blue",
                        isOutlined: showObj.isOutlined
                    )
                    show.addPalette(newObj)
                case ShowObjectType.beam.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .beam,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "blue",
                        isOutlined: showObj.isOutlined
                    )
                    show.addPalette(newObj)
                case ShowObjectType.effect.rawValue:
                    let newObj = ShowObject(
                        id: showObj.id!,
                        objType: .effect,
                        number: showObj.number,
                        name: showObj.name,
                        objColor: showObj.objColor ?? "blue",
                        isOutlined: showObj.isOutlined
                    )
                    show.addPalette(newObj)
                default:
                    continue
                }
            }
            show.groups.sort(by: {$0.number < $1.number})
            show.palettes.sort(by: {$0.number < $1.number})
        } catch {
            print(error)
        }
    }
}

//struct PPProgramPlayback_Previews: PreviewProvider {
//    static var previews: some View {
//        PPProgramPlayback()
//    }
//}
