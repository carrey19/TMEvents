//
//  TestUtils.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

@testable import TMEvents
import Foundation
import XCTest

class TestUtils {
    fileprivate static func readLocalFile(forName name: String, in bundle: Bundle) -> Data? {
        do {
            if let bundlePath = bundle.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            XCTFail("Error getting json data")
        }
        return nil
    }

    static func loadLocalJson<T: Decodable>(
        fileName: String,
        in bundle: Bundle = Bundle(for: TestUtils.self)
    ) -> Result<T, ErrorResponse> {
        guard let data = readLocalFile(forName: fileName, in: bundle) else {
            return .failure(ErrorResponse.errorReadingFile())
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return .failure(ErrorResponse.errorParsingResponse(error: "error decoding json"))
        }
        return (ParserHelper.parseObject(of: T.self, data: json))
    }
}
