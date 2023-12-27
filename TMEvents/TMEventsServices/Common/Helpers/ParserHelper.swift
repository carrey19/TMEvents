//
//  ParserHelper.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

final class ParserHelper {
    /// Parse result to a Object
    ///
    /// - Parameters:
    ///   - data: Data
    ///   - completion: Result<[T], ParserErrorResult>
    static func parseObject<T: Decodable>(of type: T.Type, data: Any, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> Result<T, ErrorResponse> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let object = try decoder.decode(T.self, from: jsonData)
            return .success(object)
        } catch {
            return .failure(ErrorResponse.errorParsingResponse(error: error.localizedDescription))
        }
    }
}
