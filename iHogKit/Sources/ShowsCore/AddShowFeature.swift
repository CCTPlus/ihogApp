// AddShowFeature.swift
//
//
//
// Follow Jay on mastodon @heyjay@iosdev.space
//               threads  @heyjaywilson
//               github   @heyjaywilson
//               website  cctplus.dev

import ComposableArchitecture
import Foundation

@Reducer
public struct AddShowFeature {
    public init() {}

    public struct State: Equatable {
        public var show: Show
        public init(show: Show = Show(id: UUID(), name: "")) {
            self.show = show
        }
    }

    public enum Action: Equatable {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)

        public enum Delegate: Equatable {
            case saveShow(Show)
        }
    }

    @Dependency(\.dismiss) var dismiss
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .cancelButtonTapped:
                    return .run { _ in await self.dismiss() }
                case .saveButtonTapped:
                    return .run { [show = state.show] send in
                        await send(.delegate(.saveShow(show)))
                        await self.dismiss()
                    }
                case .setName(let name):
                    state.show.name = name
                    return .none
                case .delegate:
                    return .none
            }
        }
    }
}
