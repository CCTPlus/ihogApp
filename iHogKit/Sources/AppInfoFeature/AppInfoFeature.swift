// AppInfoFeature.swift
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
public struct AppInfoFeature {
    public init() {}

    public struct State: Equatable {
        public var version: String

        public init(version: String = "") {
            self.version = version
        }
    }

    public enum Action {
        case versionViewLoaded
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .versionViewLoaded:
                    let appVersion =
                        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                        ?? "0.0"
                    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
                    state.version = "v\(appVersion) (\(build))"
                    return .none
            }
        }
    }
}
