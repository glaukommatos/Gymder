//
//  GymServiceTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

// swiftlint:disable force_try

import XCTest
import CoreLocation
@testable import Gymder

class GymRepositoryTests: XCTestCase {

    func testSuccessfullyGetsGyms() {
        let expectedRequest = MockDataRequest(url: expectedRequestUrl, userAgent: expectedUserAgent)
        let mockUrlSessionWrapper = MockDataProvider(setupRequests: [expectedRequest: examplePartnersResponseData])
        let partnersResponseMapper = PartnersResponseMapper()

        let gymRepository = GymRepository(
            urlSessionWrapper: mockUrlSessionWrapper,
            partnersResponseMapper: partnersResponseMapper
        )

        let expectedGyms = [
            Gym(name: "Gym 1", latitude: 12.32, longitude: 43.34, imageUrl: URL(string: "https://valid.url.com/")!)
        ]

        let expectation = XCTestExpectation()

        gymRepository.getGyms { gyms in
            switch gyms {
            case .success(let gyms):
                XCTAssertEqual(gyms, expectedGyms)
            case .failure:
                XCTFail("getGyms failed")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    func testFailsToGetGyms() {
        let mockDataProvider = MockDataProvider(setupRequests: [:])
        let partnersResponseMapper = PartnersResponseMapper()
        let gymRepository = GymRepository(
            urlSessionWrapper: mockDataProvider,
            partnersResponseMapper: partnersResponseMapper
        )

        let expectation = XCTestExpectation(description: "getGyms should complete")

        gymRepository.getGyms { result in
            switch result {
            case .success:
                XCTFail("should not have gotten a success here")
            case .failure(let error):
                XCTAssertEqual(error, .failure)
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    var expectedRequestUrl = URL(string: "https://api.one.fit/v2/en-nl/partners/city/UTR")!
    var expectedUserAgent = "OneFit/1.19.0"

    lazy var examplePartnersResponseData = try! Serialization.encoder.encode(examplePartnersResponse)
    let examplePartnersResponse = PartnersResponse(
        data: [
            PartnersResponse.Data(
                name: "Gym 1",
                headerImage: PartnersResponse.Data.Image(xxhdpi: URL(string: "https://valid.url.com/")!),
                locations: [
                    PartnersResponse.Data.Location(latitude: 12.32, longitude: 43.34)
                ]
            )
        ]
    )

}
