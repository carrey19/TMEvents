//
//  APIConfig.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

struct APIConfig {
    static let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let xml = FileManager.default.contents(atPath: path),
              let config = try? PropertyListSerialization.propertyList(
                from: xml,
                options: .mutableContainers,
                format: nil
              ) as? [String:Any],
              let apiKey = config["APIKey"] as? String else {
            fatalError("Error loading API key")
        }
        return apiKey
    }()
}
