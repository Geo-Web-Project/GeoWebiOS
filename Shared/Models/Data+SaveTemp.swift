//
//  Data+SaveTemp.swift
//  GeoWebiOS
//
//  Created by Cody Hatfield on 2023-10-27.
//

import Foundation

extension Data {
    func saveToTemporaryURL(ext: String) -> URL? {
        do {
            // Create a temporary file URL
            let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension(ext)
            
            // Write the data to the temporary file URL
            try self.write(to: temporaryFileURL, options: .atomic)
            
            return temporaryFileURL
        } catch {
            print("Error saving data to temporary URL: \(error)")
            return nil
        }
    }
}
