//
//  ChosenShow.swift
//  iHog
//
//  Created by Jay Wilson on 6/9/21.
//

import Foundation

class ChosenShow: ObservableObject {
//    private var id: UUID
    
    @Published var scenes: [ShowObject]
    @Published var lists: [ShowObject]
    @Published var groups: [ShowObject]
    @Published var palettes: [ShowObject]
    
    var playbackObjects: [ShowObject] {
        return lists + scenes
    }
    
    init(){
        scenes = []
        lists = []
        groups = []
        palettes = []
    }
    
    // MARK: Scenes
    func addScene(_ obj: ShowObject) {
        if obj.objType == .scene {
            scenes.append(obj)
        }
    }
    
    func updateScene(_ obj: ShowObject) {
        print(obj)
        if obj.objType == .scene {
            let index = scenes.firstIndex{ $0.id == obj.id }
            if index != nil {
                scenes[index!].setName(obj.name)
                scenes[index!].setNumber(obj.number)
                scenes[index!].setColor(obj.getColorString())
                scenes[index!].setOutline(obj.getOutlineState())
            } else {
                print("UPDATE SHOULD NOT HAVE BEEN CALLED")
            }
        }
    }
    
    func removeScene(_ obj: ShowObject) {
        if obj.objType == .scene {
            scenes.removeAll{ $0.id == obj.id }
        }
    }
    // MARK: Lists
    func addList(_ obj: ShowObject) {
        if obj.objType == .list {
            lists.append(obj)
        }
    }
    
    func updateList(_ obj: ShowObject) {
        if obj.objType == .list {
            let index = lists.firstIndex{ $0.id == obj.id }
            if index != nil {
                lists[index!].setName(obj.name)
                lists[index!].setNumber(obj.number)
                lists[index!].setColor(obj.getColorString())
                lists[index!].setOutline(obj.getOutlineState())
            } else {
                print("UPDATE SHOULD NOT HAVE BEEN CALLED")
            }
        }
    }
    
    func removeList(_ obj: ShowObject) {
        if obj.objType == .list {
            lists.removeAll{ $0.id == obj.id }
        }
    }
    
    // MARK: Groups
    func addGroup(_ obj: ShowObject) {
        if obj.objType == .group {
            groups.append(obj)
        }
    }
    
    func updateGroup(_ obj: ShowObject) {
        if obj.objType == .group {
            let index = groups.firstIndex{ $0.id == obj.id }
            if index != nil {
                groups[index!].setName(obj.name)
                groups[index!].setNumber(obj.number)
                groups[index!].setColor(obj.getColorString())
                groups[index!].setOutline(obj.getOutlineState())
            } else {
                print("UPDATE SHOULD NOT HAVE BEEN CALLED")
            }
        }
    }
    
    func removeGroup(_ obj: ShowObject) {
        if obj.objType == .group {
            groups.removeAll{ $0.id == obj.id }
        }
    }
    
    // MARK: Palettes
    func addPalette(_ obj: ShowObject) {
        switch obj.objType {
        case .intensity, .color, .position, .effect, .beam:
            palettes.append(obj)
        default:
            break
        }
    }
    
    func updatePalette(_ obj: ShowObject) {
        switch obj.objType {
        case .intensity, .color, .position, .effect, .beam:
            let index = palettes.firstIndex{ $0.id == obj.id }
            if index != nil {
                palettes[index!].setName(obj.name)
                palettes[index!].setNumber(obj.number)
                palettes[index!].setColor(obj.getColorString())
                palettes[index!].setOutline(obj.getOutlineState())
            } else {
                print("UPDATE SHOULD NOT HAVE BEEN CALLED")
            }
        default:
            break
        }
    }
    
    func removePalette(_ obj: ShowObject) {
        switch obj.objType {
        case .intensity, .color, .position, .effect, .beam:
            palettes.removeAll{ $0.id == obj.id }
        default:
            break
        }
    }
}
