//
//  GymServiceTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest
import CoreLocation
@testable import Gymder

class GymServiceTests: XCTestCase {

    func testExample() throws {
        let mockUrlSessionWrapper = MockURLSessionWrapper(requests: [exampleRequest:createExampleResponse(for: exampleRequest)])
        let partnersResponseMapper = PartnersResponseMapper()

        let gymService = GymService(
            urlSessionWrapper: mockUrlSessionWrapper,
            partnersResponseMapper: partnersResponseMapper
        )

        let expectation = XCTestExpectation()

        gymService.getGyms { gyms in
            XCTAssertEqual(gyms, [
                Gym(name: "Gym 1", latitude: 12.32, longitude: 43.34, imageUrl: URL(string: "https://valid.url.com/")!)
            ])

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }

    var exampleRequest: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.one.fit/v2/en-nl/partners/city/UTR")!)
        request.setValue("OneFit/1.19.0", forHTTPHeaderField: "User-Agent")
        return request
    }

    var exampleResponse: (Data?, URLResponse?, Error?) {
        (nil, nil, nil)
    }

    func createExampleResponse(for request: URLRequest) -> (Data?, URLResponse?, Error?) {
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: [:])
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase

        let responseData = try! jsonEncoder.encode(examplePartnersResponse)

        return (responseData, httpResponse, nil)
    }

    let examplePartnersResponse = PartnersResponse(
        data: [
            Partner(
                name: "Gym 1",
                headerImage: PartnerImage(mobile: URL(string: "https://valid.url.com/")!),
                locations: [
                    PartnerLocation(latitude: 12.32, longitude: 43.34)
                ]
            )
        ])
}
