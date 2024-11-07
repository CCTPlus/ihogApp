//
//  ProgrammingObjects.swift
//  iHog
//
//  Created by Jay Wilson on 9/18/20.
//

import SwiftUI
import CoreData

struct ProgrammingObjects: View {
    // MARK: Default values
    @AppStorage(Settings.chosenShowID.rawValue) var chosenShowID: String = ""
    
    // MARK: Palette defaults
    @AppStorage(Settings.buttonColorPalette.rawValue) var buttonColorPalette = 2
    @AppStorage(Settings.buttonSizePalette.rawValue) var buttonSizePalette = 0
    @AppStorage(Settings.buttonsAcrossPalette.rawValue) var buttonsAcrossPallete = 3
    @AppStorage(Settings.isButtonFilledPalette.rawValue) var isButtonFilledPalette = false
    
    // MARK: Group defaults
    @AppStorage(Settings.buttonColorGroup.rawValue) var buttonColorGroup = 0
    @AppStorage(Settings.buttonSizeGroup.rawValue) var buttonSizeGroup = 0
    @AppStorage(Settings.buttonsAcrossGroup.rawValue) var buttonsAcrossGroup = 3
    @AppStorage(Settings.isButtonFilledGroup.rawValue) var isButtonFilledGroup = false
    
    // MARK: Environment variables
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var osc: OSCHelper
    
    // MARK: State
    @State private var chosenPaletteType: Int = 0
    @State private var groupObjects: [ShowObject] = []
    @State private var paletteObjects: [ShowObject] = []
    
    @ObservedObject var show: ChosenShow
    
    // MARK: Local constants
    let paletteTypes: [ShowObjectType] = [.intensity, .position, .color, .beam, .effect]
    let sizes: [String] = ["small", "medium", "large", "extra large"]
    
    fileprivate func returnStackView() -> some View {
        return Group{
            HStack{
                ObjectGrid(
                    size: sizes[buttonSizeGroup],
                    buttonsAcross: getMaxButtonSize()[0],
                    objects: show.groups,
                    show: show
                ).padding()
                
                // MARK: Pallets
                VStack{
                    Picker("palette selection", selection: $chosenPaletteType) {
                        ForEach(0 ..< paletteTypes.count, id: \.self) {
                            Text(paletteTypes[$0].rawValue.capitalized)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    ObjectGrid(
                        size: sizes[buttonSizePalette],
                        buttonsAcross: getMaxButtonSize()[1],
                        objects: show.palettes.filter({ obj in
                            return obj.objType == paletteTypes[chosenPaletteType]
                        }),
                        show: show
                    )
                }
                
            }
        }
    }
    
    fileprivate func returnSideBySideView() -> some View {
        return Group{
            // MARK: Groups
            ObjectGrid(
                size: sizes[buttonSizeGroup],
                buttonsAcross: getMaxButtonSize()[0],
                objects: show.groups,
                show: show
            ).padding()
            
            // MARK: Pallets
            Picker("palette selection", selection: $chosenPaletteType) {
                ForEach(0 ..< paletteTypes.count, id: \.self) {
                    Text(paletteTypes[$0].rawValue.capitalized)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            ObjectGrid(
                size: sizes[buttonSizePalette],
                buttonsAcross: getMaxButtonSize()[1],
                objects: show.palettes.filter({ obj in
                    return obj.objType == paletteTypes[chosenPaletteType]
                }),
                show: show
            )
        }
    }
    
    var body: some View {
        VStack{
            // MARK: Toolbar
            HStack{
                Button(action: addGroup){
                    VStack{
                        Image(systemName: "plus.rectangle")
                        Text("Add Group")
                    }
                }
                Spacer()
                Button(action: clear){
                    VStack{
                        Image(systemName: "xmark.square")
                        Text("CLEAR")
                    }
                }.foregroundColor(.red)
                Spacer()
                Button(action: addPalette){
                    VStack{
                        Image(systemName: "plus.rectangle")
                        Text("Add \(paletteTypes[chosenPaletteType].rawValue.localizedCapitalized)")
                    }
                }
            }
            
            if horizontalSizeClass == .compact {
                if verticalSizeClass == .compact {
                    returnStackView()
                } else {
                returnSideBySideView()
                }
            }
            else {
                returnStackView()
            }
        }.padding()
        .onAppear{
            getAllObjects()
        }
    }
    
    // MARK: Add Group
    func addGroup() {
        let newGroup = ShowObject(
            id: UUID(),
            objType: .group,
            number: (Double((show.groups.count + 1))),
            objColor: OBJ_COLORS[buttonColorGroup].description,
            isOutlined: isButtonFilledGroup)
        
        show.addGroup(newGroup)
        
        let obj = ShowObjectEntity(context: viewContext)
        obj.id = newGroup.id
        obj.isOutlined = newGroup.isOutlined
        obj.number = newGroup.number
        obj.objColor = newGroup.objColor
        obj.objType = newGroup.objType.rawValue
        obj.showID = chosenShowID
        do{
            try viewContext.save()
        } catch{
            print("Error")
        }
    }
    
    // MARK: Add Palette
    func addPalette(){
        let newPalette = ShowObject(
            id: UUID(),
            objType: paletteTypes[chosenPaletteType],
            number: Double(( show.palettes
                                .filter({ obj in
                                            return obj.objType == paletteTypes[chosenPaletteType]})
                                .count) + 1 ),
            objColor: OBJ_COLORS[buttonColorPalette].description,
            isOutlined: isButtonFilledPalette)
        
        show.addPalette(newPalette)
        
        let obj = ShowObjectEntity(context: viewContext)
        obj.id = newPalette.id
        obj.isOutlined = newPalette.isOutlined
        obj.number = newPalette.number
        obj.objColor = newPalette.objColor
        obj.objType = newPalette.objType.rawValue
        obj.showID = chosenShowID
        do{
            try viewContext.save()
        } catch{
            print("Error")
        }
    }
    
    func clear(){
        osc.pushFrontPanelButton(button: ButtonFunctionNames.clear.rawValue)

        osc.releaseFrontPanelButton(button: ButtonFunctionNames.clear.rawValue)
    }
    
    // MARK: Get all objects
    func getAllObjects(){
        show.groups = []
        show.palettes = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowObjectEntity")
        fetchRequest.predicate = NSPredicate(format: "showID == %@", chosenShowID)
        
        do {
            let results = try viewContext.fetch(fetchRequest) as! [ShowObjectEntity]
            for showObj in results{
                var newObj = ShowObject(
                    id: showObj.id!,
                    objType: .group,
                    number: showObj.number,
                    name: showObj.name,
                    objColor: showObj.objColor ?? "red",
                    isOutlined: showObj.isOutlined
                )
                switch showObj.objType {
                case ShowObjectType.group.rawValue:
                    show.addGroup(newObj)
                case ShowObjectType.intensity.rawValue:
                    newObj.objType = .intensity
                    show.addPalette(newObj)
                case ShowObjectType.position.rawValue:
                    newObj.objType = .position
                    show.addPalette(newObj)
                case ShowObjectType.color.rawValue:
                    newObj.objType = .color
                    show.addPalette(newObj)
                case ShowObjectType.beam.rawValue:
                    newObj.objType = .beam
                    show.addPalette(newObj)
                case ShowObjectType.effect.rawValue:
                    newObj.objType = .effect
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
    
    // Returns: Integer array of 2. First index is groups
    //          Second index is palettes
    func getMaxButtonSize() -> [Int]{
        switch horizontalSizeClass {
        case .compact:
            return [getGroupButtonsAcross(), getPaletteButtonsAcross()]
        default:
            return [getGroupButtonsAcross(), getPaletteButtonsAcross()]
        }
    }
    
    func getPaletteButtonsAcross() -> Int{
        switch buttonSizePalette {
        // small
        case 0:
            if buttonsAcrossPallete <= SMALL_MAX_BUTTONS_ACROSS {
                return buttonsAcrossPallete
            }
            return SMALL_MAX_BUTTONS_ACROSS
        // medium
        case 1:
            if buttonsAcrossPallete <= MEDIUM_MAX_BUTTONS_ACROSS {
                return buttonsAcrossPallete
            }
            return MEDIUM_MAX_BUTTONS_ACROSS
        // large
        case 2:
            return LARGE_MAX_BUTTONS_ACROSS
        // extra large
        default:
            return XL_MAX_BUTTONS_ACROSS
        }
    }
    
    func getGroupButtonsAcross() -> Int{
        switch buttonSizeGroup {
        // small
        case 0:
            if buttonsAcrossGroup <= SMALL_MAX_BUTTONS_ACROSS {
                return buttonsAcrossGroup
            }
            return SMALL_MAX_BUTTONS_ACROSS
        // medium
        case 1:
            if buttonsAcrossGroup <= MEDIUM_MAX_BUTTONS_ACROSS {
                return buttonsAcrossGroup
            }
            return MEDIUM_MAX_BUTTONS_ACROSS
        // large
        case 2:
            return LARGE_MAX_BUTTONS_ACROSS
        // extra large
        default:
            return XL_MAX_BUTTONS_ACROSS
        }
    }
}

//struct ProgrammingObjects_Previews: PreviewProvider {
//    static var previews: some View {
//        ProgrammingObjects()
//    }
//}
