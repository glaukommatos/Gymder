//
//  PartnersResponse.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

// swiftlint:disable nesting

import Foundation

struct PartnersResponse: Codable, Equatable {
    let data: [Data]

    struct Data: Codable, Equatable {
        let name: String
        let headerImage: Image
        let locations: [Location]

        struct Image: Codable, Equatable {
            let mobile: URL
        }

        struct Location: Codable, Equatable {
            let latitude: Double
            let longitude: Double
        }
    }
}
