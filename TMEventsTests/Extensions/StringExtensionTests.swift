//
//  StringExtensionTests.swift
//  TMEventsTests
//
//  Created by Juan Carlos Carrera Reyes on 26/12/23.
//

import XCTest
@testable import TMEvents

final class StringExtensionTests: XCTestCase {
    func test_castToMonthFormatDate_success() {
        // Given
        let sut = "2024-01-19"
        let expectedDateMonthFormat = "Jan 19 2024"

        // When
        let result = sut.toMonthFormatDate()

        // Then
        XCTAssertEqual(result, expectedDateMonthFormat)
    }

    func test_castToMonthFormatDate_failed_keepTheOriginalFormat() {
        // Given
        let sut = "2024-01-20T04:00:00Z"

        // When
        let result = sut.toMonthFormatDate()

        // Then
        XCTAssertEqual(result, sut)
    }

}
