//
//  DiscoveryRequest.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

enum DiscoveryRequest: RequestProtocol {
    case events(keyword: String)

    var baseURL: URL {
        return URL(string: "https://app.ticketmaster.com")!
    }

    var path: String {
        switch self {
        case .events:
            return "/discovery/v2/events.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .events:
            return .get
        }
    }

    var timeoutInterval: TimeInterval {
        return 20.0
    }

    var pathParameters: PathParameters {
        var parameters: PathParameters = PathParameters()
        switch self {
        case .events(let keyword):
            parameters[.apikey] = APIConfig.apiKey
            parameters[.keyword] = keyword
            return parameters
        }
    }

    var parameters: [String : Any] {
        return [:]
    }
}
