//
//  Router.swift
//  iHog
//
//  Created by Jay Wilson on 11/24/24.
//

import Foundation

@Observable
@MainActor
public final class Router {
  public var selectedTab: AppTab = .settings
  public var presentedSheet: SheetDestination?
  public var showName: String?

  private var showID: UUID?

  private var paths: [AppTab: [RouterDestination]] = [:]

  public init(showID: UUID? = nil, showName: String? = nil) {
    self.showID = showID
    self.showName = showName
  }

  public var selectedTabPath: [RouterDestination] {
    paths[selectedTab] ?? []
  }

  public func popToRoot(for tab: AppTab? = nil) {
    paths[tab ?? selectedTab] = []
  }

  public func changeShow(to id: UUID, with name: String) {
    showID = id
    showName = name
  }

  public func navigate(to destination: RouterDestination, for tab: AppTab? = nil) {
    paths[tab ?? selectedTab]?.append(destination)
  }

  public func navigateBack(on tab: AppTab? = nil) {
    paths[tab ?? selectedTab]?.removeLast()
  }
}
