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
        let imageUrl = URL(string: "https://valid.url.com/image.png")!
        let headerImage = PartnersResponse.Data.Image(
            desktop: imageUrl,
            xxxhdpi: imageUrl,
            xxhdpi: imageUrl,
            xhdpi: imageUrl,
            hdpi: imageUrl
        )

        let partnersResponse = PartnersResponse(
            data: [
                PartnersResponse.Data(
                    name: "Gym 1",
                    headerImage: headerImage,
                    locations: [
                        PartnersResponse.Data.Location(latitude: 12.32, longitude: 43.34)
                    ]
                )
        ])

        let mapper = PartnersResponseMapper()
        let gyms = mapper.map(response: partnersResponse)

        let expectedGyms = [
            Gym(
                name: "Gym 1",
                latitude: 12.32,
                longitude: 43.34,
                imageUrl: URL(string: "https://valid.url.com/image.png")!
            )
        ]

        XCTAssertEqual(gyms, expectedGyms)
    }
}
