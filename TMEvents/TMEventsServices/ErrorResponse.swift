//
//  ErrorResponse.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

public struct ErrorResponse: Error, LocalizedError, Equatable {

    private static let defaultErrorCode = "API_ERROR"
    private static let defaultErrorType = "Internal"
    private static let defaultErrorNetwork = "Error"

    let code: String
    let type: String
    let error: String

    static func errorRecuestfailed(error: String) -> ErrorResponse {
        return ErrorResponse(code: defaultErrorCode, type: defaultErrorType, error: error)
    }

    static func errorNotDataFromResponse() -> ErrorResponse {
        return ErrorResponse(code: defaultErrorCode, type: defaultErrorType, error: "Data nil from response")
    }

    static func errorSerializationData(error: String) -> ErrorResponse {
        return ErrorResponse(code: defaultErrorCode, type: defaultErrorType, error: error)
    }

    static func errorParsingResponse(error: String) -> ErrorResponse {
        return ErrorResponse(code: defaultErrorCode, type: defaultErrorType, error: error)
    }

    static func errorWithMessage(_ message:String) -> ErrorResponse {
        return ErrorResponse(code: defaultErrorCode, type: defaultErrorType, error: message)
    }

    static func errorReadingFile() -> ErrorResponse {
        return ErrorResponse(code: defaultErrorCode, type: defaultErrorType, error: "errorReadingFile")
    }

    static func errorNetwork() -> ErrorResponse {
        return ErrorResponse(code: defaultErrorNetwork, type: defaultErrorType, error: "You're currently offline")
    }
}
