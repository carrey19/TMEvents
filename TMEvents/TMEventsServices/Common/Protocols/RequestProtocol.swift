//
//  RequestProtocol.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

/// Defines methods for RequestProtocol compatibility.
/// Concrete Request Services can implement it to add `RequestProtocol` compatiblity.
protocol RequestProtocol {
    /// An baseURL String
    var baseURL: URL { get }
    /// Path of specific service to request
    var path: String { get }
    /// `PathParameters` parameters required to make the `URLRequest` of an specific Service or API.
    var pathParameters: PathParameters { get }
    /// `HTTP Method GET-POST-DELETE` required to make the `URLRequest` of an specific Service or API.
    var method: HTTPMethod { get }
    /// `TimeInterval` for obtaining request data.
    var timeoutInterval: TimeInterval { get }
    /// `Parameters` required to make the `URLRequest` of an specific Service or API.
    var parameters: [String: Any] { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}
