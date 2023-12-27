//
//  RequestFactory.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

typealias APIResult<T> = (Result<T,ErrorResponse>) -> Void
typealias RequestResult = (Result<Any, ErrorResponse>) -> Void

struct RequestFactory {
    func request(service: RequestProtocol, completion: @escaping RequestResult) {
        let request = makeRequest(service: service)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let sessionError = error {
                completion(.failure(ErrorResponse.errorRecuestfailed(error: sessionError.localizedDescription)))
                return
            }
            guard let responseData = data else {
                completion(.failure(ErrorResponse.errorNotDataFromResponse()))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                completion(.success(json))
            } catch {
                completion(.failure(ErrorResponse.errorSerializationData(error: error.localizedDescription)))
            }
        }.resume()
    }

    private func makeRequest(service: RequestProtocol) -> URLRequest {
        guard let urlStr = service.baseURL.appendingPathComponent(service.path).absoluteString.removingPercentEncoding else {
            return URLRequest(url: service.baseURL)
        }
        var urlComponents = URLComponents(string: urlStr)
        urlComponents?.queryItems = service.pathParameters.toQueryItems()
        guard let url = urlComponents?.url else { return URLRequest(url: service.baseURL) }
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: service.timeoutInterval)
        request.httpMethod = service.method.rawValue
        switch service.method {
        case .post, .put:
            guard let httpBody = try? JSONSerialization.data(withJSONObject: service.parameters, options: []) else {
                return request
            }
            request.httpBody = httpBody
        default:
            return request
        }
        return request
    }
}
