//
//  ChosenShowTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 6/9/21.
//

import XCTest
@testable import iHog

class ChosenShowTests: XCTestCase {
    var sut: ChosenShow!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ChosenShow()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func test_ChosenShowInit_ShouldHaveNoObjects() {
        let listCount = sut.lists.count
        let sceneCount = sut.scenes.count
        let groupCount = sut.groups.count
        let paletteCount = sut.palettes.count
        
        XCTAssertEqual(listCount, 0, "List count check")
        XCTAssertEqual(sceneCount, 0, "scene count check")
        XCTAssertEqual(groupCount, 0, "Group count check")
        XCTAssertEqual(paletteCount, 0, "Palette count check")
    }
    
    // MARK: Testing Scenes
    func test_ChosenShowAddScene_ShouldHave1Scene() {
        let testScene = ShowObject(objType: .scene,
                                   number: 1,
                                   objColor: "red")
        
        sut.addScene(testScene)
        XCTAssertEqual(sut.scenes, [testScene])
    }
    
    func test_ChosenShowAddScenes_ShouldHave500Scenes() {
        
        for n in 1...500 {
            let tempScene = ShowObject(objType: .scene,
                                       number: Double(n),
                                       objColor: "red")
            sut.addScene(tempScene)
        }
        
        XCTAssertEqual(sut.scenes.count, 500)
    }
    
    func test_ChosenShowAddScenes_ShouldNotHaveScene(){
        let testObj = ShowObject(objType: .list, number: 1, objColor: "green")
        sut.addScene(testObj)
        XCTAssertEqual(sut.scenes.count, 0)
    }
    
    func test_ChosenShowUpdateSceneName_ShouldHaveOut(){
        let SAMPLE_SCENE = ShowObject(objType: .scene,
                                      number: 1,
                                      objColor: "red")
        sut.addScene(SAMPLE_SCENE)
        
        var updatedScene = SAMPLE_SCENE
        updatedScene.setName("Out")
        
        sut.updateScene(updatedScene)
        XCTAssertEqual(sut.scenes[0].getName(), "Out")
    }
    func test_ChosenShowUpdateSceneNumber_ShouldChange10(){
        let SAMPLE_SCENE = ShowObject(objType: .scene,
                                      number: 1,
                                      objColor: "red")
        sut.addScene(SAMPLE_SCENE)
        
        var updatedScene = SAMPLE_SCENE
        updatedScene.setNumber(10)
        
        sut.updateScene(updatedScene)
        XCTAssertEqual(sut.scenes[0].getName(), "Scene 10")
    }
    
    func test_ChosenShowUpdateSceneName_ShouldHaveOutAt10Scene(){
        for n in 1...500 {
            let tempScene = ShowObject(objType: .scene,
                                       number: Double(n),
                                       objColor: "red")
            sut.addScene(tempScene)
        }
        
        var updatedScene = sut.scenes[10]
        updatedScene.setName("Out")
        
        sut.updateScene(updatedScene)
        XCTAssertEqual(sut.scenes[10].getName(), "Out")
    }
    
    func test_ChosenShowUpdateScene_ShouldNotChange(){
        let SAMPLE_SCENE = ShowObject(objType: .scene,
                                      number: 1,
                                      objColor: "red")
        sut.addScene(SAMPLE_SCENE)
        
        var updatedScene = SAMPLE_SCENE
        updatedScene.objType = .list
        updatedScene.setName("Testing")
        
        sut.updateScene(updatedScene)
        XCTAssertEqual(sut.scenes[0].getName(), "Scene 1")
    }
    
    func test_RemoveScene_ShouldHave0Scenes(){
        let SAMPLE_SCENE = ShowObject(objType: .scene,
                                      number: 1,
                                      objColor: "red")
        sut.addScene(SAMPLE_SCENE)
        sut.removeScene(SAMPLE_SCENE)
        XCTAssert(sut.scenes.count == 0)
    }
    
    func test_RemoveScene_ShouldHave499Scenes(){
        for n in 1...500 {
            let tempScene = ShowObject(objType: .scene,
                                       number: Double(n),
                                       objColor: "red")
            sut.addScene(tempScene)
        }
        
        let removedScene = sut.scenes[10]
        
        sut.removeScene(removedScene)
        XCTAssertFalse(sut.scenes[10] == removedScene)
    }
    
    func test_RemoveScene_ShouldNotChange(){
        let SAMPLE_SCENE = ShowObject(objType: .scene,
                                      number: 1,
                                      objColor: "red")
        
        let SAMPLE_LIST = ShowObject(objType: .list,
                                          number: 1,
                                          objColor: "red")
        sut.addScene(SAMPLE_LIST)
        sut.addScene(SAMPLE_SCENE)
        
        sut.removeScene(SAMPLE_LIST)
        XCTAssertEqual(sut.scenes[0].getName(), "Scene 1")
        
    }
    
    // MARK: Testing Lists
    func test_ChosenShowAddList_ShouldHave1List() {
        let testList = ShowObject(objType: .list,
                                   number: 1,
                                   objColor: "red")
        
        sut.addList(testList)
        XCTAssertEqual(sut.lists, [testList])
    }
    
    func test_ChosenShowAddLists_ShouldHave10Lists() {
        
        for n in 1...500 {
            let tempList = ShowObject(objType: .list,
                                       number: Double(n),
                                       objColor: "red")
            sut.addList(tempList)
        }
        
        XCTAssertEqual(sut.lists.count, 500)
    }
    
    func test_ChosenShowUpdateListName_ShouldHaveOut(){
        let SAMPLE_TEST = ShowObject(objType: .list,
                                      number: 1,
                                      objColor: "red")
        sut.addList(SAMPLE_TEST)
        
        var updatedList = SAMPLE_TEST
        updatedList.setName("Out")
        
        sut.updateList(updatedList)
        XCTAssertEqual(sut.lists[0].getName(), "Out")
    }
    
    func test_ChosenShowUpdateListName_ShouldHaveOutAt10Scene(){
        for n in 1...500 {
            let tempList = ShowObject(objType: .list,
                                       number: Double(n),
                                       objColor: "red")
            sut.addList(tempList)
        }
        
        var updatedLists = sut.lists[10]
        updatedLists.setName("Out")
        
        sut.updateList(updatedLists)
        XCTAssertEqual(sut.lists[10].getName(), "Out")
    }
    
    func test_RemoveList_ShouldHave0Lists(){
        let SAMPLE_LIST = ShowObject(objType: .list,
                                      number: 1,
                                      objColor: "red")
        sut.addList(SAMPLE_LIST)
        sut.removeList(SAMPLE_LIST)
        XCTAssert(sut.lists.count == 0)
    }
    
    func test_RemoveList_ShouldHave499Lists(){
        for n in 1...500 {
            let tempList = ShowObject(objType: .list,
                                       number: Double(n),
                                       objColor: "red")
            sut.addList(tempList)
        }
        
        let removedList = sut.lists[10]
        
        sut.removeList(removedList)
        XCTAssertFalse(sut.lists[10] == removedList)
    }
    
    // MARK: Testing Groups
    func test_ChosenShowAddGroups_ShouldHave1Group() {
        let SAMPLE_GROUP = ShowObject(objType: .group, number: 1, objColor: "red")
        sut.addGroup(SAMPLE_GROUP)
        XCTAssertEqual(sut.groups, [SAMPLE_GROUP])
    }
    
    func test_ChosenShowAddGroups_ShouldHave500Groups() {
        for n in 1...500 {
            let tempGroup = ShowObject(objType: .group, number: Double(n), objColor: "red")
            
            sut.addGroup(tempGroup)
        }
        
        XCTAssertEqual(sut.groups.count, 500)
    }
    
    func test_ChosenShowAddGroup_ShouldNotHaveGroup(){
        let testObj = ShowObject(objType: .list, number: 1, objColor: "green")
        sut.addGroup(testObj)
        XCTAssertEqual(sut.groups.count, 0)
    }
    
    func test_ChosenShowUpdateGroupName_ShouldHaveOut(){
        let SAMPLE_GROUP = ShowObject(objType: .group, number: 1, objColor: "red")
        sut.addGroup(SAMPLE_GROUP)
        
        var updatedGroup = SAMPLE_GROUP
        updatedGroup.setName("OUT")
        
        sut.updateGroup(updatedGroup)
        
        XCTAssertEqual(sut.groups[0].getName(), "OUT")
    }
    
    func test_RemoveGroup_ShouldHave0Groups() {
        let SAMPLE_GROUP = ShowObject(objType: .group, number: 1, objColor: "red")
        sut.addGroup(SAMPLE_GROUP)
        
        sut.removeGroup(SAMPLE_GROUP)
        
        XCTAssertEqual(sut.groups.count, 0)
    }
    
    // MARK: Testing Palettes
    func test_ChosenShowAddPalettes_ShouldHave1Palette() {
        let SAMPLE_PALETTE = ShowObject(objType: .position, number: 1, objColor: "red")
        sut.addPalette(SAMPLE_PALETTE)
        XCTAssertEqual(sut.palettes, [SAMPLE_PALETTE])
    }
    
    func test_ChosenShowAddPalettes_ShouldHave500Palettes() {
        for n in 1...500 {
            let tempPalette = ShowObject(objType: .position, number: Double(n), objColor: "red")
            
            sut.addPalette(tempPalette)
        }
        
        XCTAssertEqual(sut.palettes.count, 500)
    }
    
    func test_ChosenShowAddPalette_ShouldNotHavePalette(){
        let testObj = ShowObject(objType: .group, number: 1, objColor: "green")
        sut.addPalette(testObj)
        XCTAssertEqual(sut.palettes.count, 0)
    }
    
    func test_ChosenShowUpdatePaletteName_ShouldHaveOut(){
        let SAMPLE_PALETTE = ShowObject(objType: .position, number: 1, objColor: "red")
        sut.addPalette(SAMPLE_PALETTE)
        
        var updatedPalette = SAMPLE_PALETTE
        updatedPalette.setName("OUT")
        
        sut.updatePalette(updatedPalette)
        
        XCTAssertEqual(sut.palettes[0].getName(), "OUT")
    }
    
    func test_RemovePalette_ShouldHave0Palettes() {
        let SAMPLE_PALETTE = ShowObject(objType: .position, number: 1, objColor: "red")
        sut.addPalette(SAMPLE_PALETTE)
        
        sut.removePalette(SAMPLE_PALETTE)
        
        XCTAssertEqual(sut.palettes.count, 0)
    }
}
