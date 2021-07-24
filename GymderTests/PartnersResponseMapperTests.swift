//
//  PartnersResponseMapperTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest
@testable import Gymder

class PartnersResponseMapperTests: XCTestCase {

    func testExample() throws {
        let partnersResponse = PartnersResponse(
            data: [
                Partner(
                    name: "Gym 1",
                    headerImage: PartnerImage(mobile: URL(string: "https://valid.url.com/")!),
                    locations: [
                        PartnerLocation(latitude: 12.32, longitude: 43.34)
                    ]
                )
        ])

        let mapper = PartnersResponseMapper()
        let gyms = mapper.map(response: partnersResponse)

        let expectedGyms = [
            Gym(name: "Gym 1", latitude: 12.32, longitude: 43.34, imageUrl: URL(string: "https://valid.url.com/")!)
        ]

        XCTAssertEqual(gyms, expectedGyms)
    }
}
