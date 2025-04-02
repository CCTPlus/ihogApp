//
// -----------------------------------------------------------
// Project: iHog
// Created on 4/1/25 by @HeyJayWilson
// -----------------------------------------------------------
// Find HeyJayWilson on the web:
// 🕸️ Website             https://heyjaywilson.com
// 💻 Follow on GitHub:   https://github.com/heyjaywilson
// 🧵 Follow on Threads:  https://threads.net/@heyjaywilson
// 💭 Follow on Mastodon: https://iosdev.space/@heyjaywilson
// ☕ Buy me a ko-fi:     https://ko-fi.com/heyjaywilson
// -----------------------------------------------------------
// Copyright© 2025 CCT Plus LLC. All rights reserved.
//

@preconcurrency import CoreData

public struct HogData {
  /// Core Data model for the iHog app
  /// Loads the model from the package's Resources directory
  public static let model: NSManagedObjectModel = {
    // First try xcdatamodel
    if let modelURL = Bundle.module.url(forResource: "iHog", withExtension: "xcdatamodel") {
      print("Found model at: \(modelURL)")
      if let model = NSManagedObjectModel(contentsOf: modelURL) {
        return model
      }
      print("Failed to load xcdatamodel")
    } else {
      print("No xcdatamodel found")
    }

    // Then try xcdatamodeld
    if let modelURL = Bundle.module.url(forResource: "iHog", withExtension: "xcdatamodeld") {
      print("Found model at: \(modelURL)")
      if let model = NSManagedObjectModel(contentsOf: modelURL) {
        return model
      }
      print("Failed to load xcdatamodeld")
    } else {
      print("No xcdatamodeld found")
    }

    // Finally try momd
    if let modelURL = Bundle.module.url(forResource: "iHog", withExtension: "momd") {
      print("Found model at: \(modelURL)")
      if let model = NSManagedObjectModel(contentsOf: modelURL) {
        return model
      }
      print("Failed to load momd")
    } else {
      print("No momd found")
    }

    // Print available resources for debugging
    print("Available resources in bundle:")
    Bundle.module.urls(forResourcesWithExtension: nil, subdirectory: nil)?
      .forEach {
        print($0)
      }

    fatalError("Failed to find and load any version of iHog Core Data model")
  }()
}
