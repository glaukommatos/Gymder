//
//  PartnersResponse.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

struct PartnersResponse: Codable, Equatable {
    let data: [Data]
}

extension PartnersResponse {
    struct Data: Codable, Equatable {
        let name: String
        let headerImage: Image
        let locations: [Location]
    }
}

extension PartnersResponse.Data {
    struct Image: Codable, Equatable {
        let desktop: URL
        let xxxhdpi: URL
        let xxhdpi: URL
        let xhdpi: URL
        let hdpi: URL
    }
}

extension PartnersResponse.Data {
    struct Location: Codable, Equatable {
        let latitude: Double
        let longitude: Double
    }
}
