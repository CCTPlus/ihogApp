// File.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import ComposableArchitecture
import Foundation

extension ShowsFeature {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case addShow(AddShowFeature.State)
            case alert(AlertState<ShowsFeature.Action.Alert>)
        }

        public enum Action {
            case addShow(AddShowFeature.Action)
            case alert(ShowsFeature.Action.Alert)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.addShow, action: \.addShow) {
                AddShowFeature()
            }
        }
    }
}
