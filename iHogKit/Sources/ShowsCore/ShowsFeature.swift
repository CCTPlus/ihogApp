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
        @PresentationState public var destination: Destination.State?

        public var shows: [Show]

        public init(destination: Destination.State? = nil, shows: [Show] = []) {
            self.destination = destination
            self.shows = shows
        }
    }

    public enum Action {
        case addButtonTapped
        case deleteButtonTapped(id: UUID)
        case destination(PresentationAction<Destination.Action>)

        public enum Alert: Equatable {
            case confirmDeletion(id: UUID)
        }
    }
    @Dependency(\.uuid) var uuid
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .addButtonTapped:
                    state.destination = .addShow(
                        AddShowFeature.State(
                            show: Show(
                                id: self.uuid(),
                                name: ""
                            )
                        )
                    )
                    return .none
                case .destination(.presented(.addShow(.delegate(.saveShow(let show))))):
                    state.shows.append(show)
                    return .none
                case .destination(.presented(.alert(.confirmDeletion(id: let id)))):
                    state.shows.removeAll(where: { $0.id == id })
                    return .none
                case .destination:
                    return .none
                case .deleteButtonTapped(let id):
                    state.destination = .alert(
                        AlertState {
                            TextState("Are you sure?")
                        } actions: {
                            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                                TextState("Delete")
                            }
                        }
                    )
                    return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
