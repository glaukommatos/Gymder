//
//  GymDataSourceCodableModels.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

struct PartnersResponse: Codable, Equatable {
    let data: [Partner]
}

struct Partner: Codable, Equatable {
    let name: String
    let headerImage: PartnerImage
    let locations: [PartnerLocation]
}

struct PartnerImage: Codable, Equatable {
    let mobile: URL
}

struct PartnerLocation: Codable, Equatable {
    let latitude: Double
    let longitude: Double
}
