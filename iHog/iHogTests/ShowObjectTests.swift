//
//  ShowObjectTests.swift
//  iHogTests
//
//  Created by Jay Wilson on 6/8/21.
//

import XCTest
@testable import iHog

class ShowObjectTests: XCTestCase {
    var sut: ShowObject!

    override func setUp() {
        sut = ShowObject(objType: .group, number: 10, objColor: "red")
    }

    override func tearDown() {
        sut = nil
    }

    func disable_testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func disable_testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: Name Tests
    // Test for initial obj with no name given
    func test_ShowObjectName_NoNameGiven_ShouldBeGroup10() throws {
        let name = sut.getName()
        XCTAssertEqual(name, "Group 10")
    }
    
    // Test for object name change
    func test_ShowObjectName_AfterSetName_ShouldBeWash() throws {
        sut.setName("Wash")
        let name = sut.getName()
        XCTAssertEqual(name, "Wash")
    }
    
    // MARK: Number Tests
    // Test for initial number
    func test_ShowObjectNumber_Initial_ShouldBe10() throws {
        let number = sut.getObjNumber()
        XCTAssertEqual(number, "10")
    }
    
    // Test for whole number change
    
    func test_ShowObjectNumber_AfterSetNum_ShouldBe5() throws {
        sut.setNumber(5)
        let number = sut.getObjNumber()
        XCTAssertEqual(number, "5")
    }
    
    // Test dot numbers
    func test_ShowObjectNumber_AfterSetNum_ShouldBe10dot1() throws {
        sut.setNumber(10.1)
        let number = sut.getObjNumber()
        XCTAssertEqual(number, "10.1")
    }
    
    // MARK: Outline Testing
    
    func test_ShowObjectOutline_Initial_ShouldBeTrue() throws {
        let outline = sut.getOutlineState()
        XCTAssertTrue(outline)
    }
    
    func test_ShowObjectOutline_AfterSetOutline_ShouldBeFalse() throws {
        sut.setOutline(false)
        let outline = sut.getOutlineState()
        XCTAssertFalse(outline)
    }
    
    func test_ShowObjectOutline_AfterSetOutline_ShouldBeTrue() throws {
        sut.setOutline(false)
        let outlineFalse = sut.getOutlineState()
        XCTAssertFalse(outlineFalse)
        
        sut.setOutline(true)
        let outlineTrue = sut.getOutlineState()
        XCTAssertTrue(outlineTrue)
    }
    
    // MARK: Color Testing
    func test_ShowObjectColor_Initial_ShouldBeRed() throws {
        let color = sut.getColorString()
        XCTAssertEqual(color, "red")
    }

    func test_ShowObjectColor_AfterSetColor_ShouldBeBlue() throws {
        sut.setColor("blue")
        let color = sut.getColorString()
        XCTAssertEqual(color, "blue")
    }
}
