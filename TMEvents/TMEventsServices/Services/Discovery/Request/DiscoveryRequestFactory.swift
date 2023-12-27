//
//  DiscoveryRequestFactory.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

typealias DiscoveryResponse = APIResult<DiscoveryEvents?>

struct DiscoveryRequestFactory: DiscoveryServiceProtocol {
    private let requestFactory = RequestFactory()

    func searchEventsBy(keyword: String, completion: @escaping DiscoveryResponse) {
        let service = DiscoveryRequest.events(keyword: keyword)
        requestFactory.request(service: service) { result in
            switch result {
            case let .success(data):
                completion(ParserHelper.parseObject(of: DiscoveryEvents?.self, data: data))
            case let .failure(failure):
                completion(.failure(failure))
            }
        }
    }
}
