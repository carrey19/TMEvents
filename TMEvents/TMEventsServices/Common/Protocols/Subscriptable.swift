//
//  Subscriptable.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

protocol Subscriptable {
    associatedtype Name: Hashable
    subscript(index: Name) -> String { get set }
}
