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

import Foundation

extension Data {
  /// Saves the data to a file in the Documents Directory
  /// - Parameter fileName: the name of the file
  /// - Returns: the URL of newly created file. Will throw if it can't create the file.
  public func dataToFile(fileName: String) throws -> URL? {
    let data = self

    do {
      let documentDirectoryURL = try FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: true
      )

      // Make the file path (with the filename) where the file will be loacated after it is created
      let filePath = documentDirectoryURL.appendingPathComponent(fileName)

      // Write the file from data into the filepath (if there will be an error, the code will throws)
      try data.write(to: filePath)

      // Returns the URL where the new file is located in NSURL
      return filePath
    }
  }
}
