//
//  PathParameters.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

struct PathParameters: Subscriptable {
    private var collection: [PathParameterName:String] = [:]

    subscript(index: PathParameterName) -> String {
        get { return collection[index] ?? "" }
        set { collection[index] = newValue }
    }

    func toQueryItems() -> [URLQueryItem] {
        return collection.map { key, value in
            URLQueryItem(name: key.rawValue, value: value)
        }
    }
}
