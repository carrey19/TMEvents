//
//  MockDiscoveryRequestFactory.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

@testable import TMEvents

final class MockDiscoveryRequestFactory: DiscoveryServiceProtocol {
    let fileName = "MockDiscoveryEventsResponse"
    var isSuccess = true
    var errorResponse: ErrorResponse = ErrorResponse.errorRecuestfailed(error: "bad request")
    func searchEventsBy(keyword: String, completion: @escaping DiscoveryResponse) {
        if isSuccess {
            let response: Result<DiscoveryEvents,ErrorResponse> = TestUtils.loadLocalJson(fileName: fileName)
            switch response {
            case .success(let events):
                return completion(.success(events))
            case .failure(let error):
                completion(.failure(error))
            }
        } else {
            return completion(.failure(errorResponse))
        }
    }
}
