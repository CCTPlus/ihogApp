// ShowsCoreTests.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import ComposableArchitecture
import XCTest

@testable import ShowsCore

@MainActor
final class ShowsCoreTests: XCTestCase {
  func testAddFlow() async {
    let store = TestStore(initialState: ShowsFeature.State(), reducer: { ShowsFeature() })

    //        await store.send(.addButtonTapped) {
    //            $0.destination = .addShow()
    //        }
  }
}
