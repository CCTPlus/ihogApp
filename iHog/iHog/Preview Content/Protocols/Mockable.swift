//
//  Mockable.swift
//  iHog
//
//  Created by Jay on 2/9/24.
//

import Foundation

protocol Mockable {
  associatedtype MockType

  static var mock: MockType { get }
  static var mockList: [MockType] { get }
}

extension Mockable {
  static var mockList: [MockType] {
    []
  }
}
