// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 17.0, *)
@Observable
public final class AppRouter {
  public var selectedSheet: SheetDestination?

  public init(selectedSheet: SheetDestination? = nil) {
    self.selectedSheet = selectedSheet
  }

  public func openSheet(_ destination: SheetDestination) {
    selectedSheet = destination
  }
}
