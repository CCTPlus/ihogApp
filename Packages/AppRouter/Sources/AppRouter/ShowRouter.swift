//
//  ShowRouter.swift
//  AppRouter
//
//  Created by Jay Wilson on 1/3/25.
//

import Foundation

@available(iOS 17.0, *)
@Observable
public final class ShowRouter {
  public var selectedTab: ShowTab = .programmingObjects
  public var showSheet: ShowSheet? = nil
  var showID: UUID

  public init(selectedTab: ShowTab = .programmingObjects, showID: UUID, showSheet: ShowSheet? = nil)
  {
    self.selectedTab = selectedTab
    self.showID = showID
    self.showSheet = showSheet
  }

  func openSheet(_ sheet: ShowSheet) {
    showSheet = sheet
  }
}
