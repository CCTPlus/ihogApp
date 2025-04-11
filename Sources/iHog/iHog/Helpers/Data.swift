//
//  Data.swift
//  iHog
//
//  Created by Jay Wilson on 11/15/24.
//

import Foundation

extension Data {
  /// Saves the data to a file in the Documents Directory
  /// - Parameter fileName: the name of the file
  /// - Returns: the URL of newly created file. Will throw if it can't create the file.
  func dataToFile(fileName: String) throws -> URL? {
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
