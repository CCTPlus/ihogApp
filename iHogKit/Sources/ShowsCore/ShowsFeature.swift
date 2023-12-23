// ShowsFeature.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import ComposableArchitecture
import Foundation

public struct Show: Equatable, Identifiable {
    public let id: UUID
    public var name: String

    public init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

@Reducer
public struct ShowsFeature {
    public init() {}

    public struct State: Equatable {
        @PresentationState public var addShow: AddShowFeature.State?

        public var shows: [Show]

        public init(addShow: AddShowFeature.State? = nil, shows: [Show] = []) {
            self.addShow = addShow
            self.shows = shows
        }
    }

    public enum Action {
        case addButtonTapped
        case addShow(PresentationAction<AddShowFeature.Action>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .addButtonTapped:
                    state.addShow = AddShowFeature.State(show: Show(id: UUID(), name: ""))
                    return .none
                case .addShow(.presented(.delegate(.saveShow(let show)))):
                    state.shows.append(show)
                    return .none
                case .addShow:
                    return .none
            }
        }
        .ifLet(\.$addShow, action: \.addShow) {
            AddShowFeature()
        }
    }
}
