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
        let store = TestStore(initialState: ShowsFeature.State()){ ShowsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }

        await store.send(.addButtonTapped) {
            $0.destination = .addShow(AddShowFeature.State(show: Show(id: UUID(0), name: "")))
        }
        await store.send(.destination(.presented(.addShow(.setName("HeyJayWilson.live"))))) {
            $0.$destination[case: \.addShow]?.show.name = "HeyJayWilson.live"
        }

        await store.send(.destination(.presented(.addShow(.saveButtonTapped))))
//        await store.receive(
//            .destination(
//                .presented(
//                    .addShow(
//                        .delegate(.saveShow(
//                            Show(id: UUID(0),
//                                 name: "HeyJayWilson.live")
//                        ))
//                    )
//                )
//            )
//        ) {
//            $0.shows = [
//                Show(id: UUID(0), name: "HeyJayWilson.live")
//            ]
//        }
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
}
