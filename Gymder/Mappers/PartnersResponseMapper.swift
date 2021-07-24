//
//  PartnersResponseMapper.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation
import CoreLocation

protocol PartnersResponseMapperProtocol {
    func map(response: PartnersResponse) -> [Gym]
}

class PartnersResponseMapper: PartnersResponseMapperProtocol {
    func map(response: PartnersResponse) -> [Gym] {
        response.data.flatMap { partner in
            partner.locations.map { location in
                Gym(name: partner.name,
                    latitude: location.latitude,
                    longitude: location.longitude,
                    imageUrl: partner.headerImage.mobile)
            }
        }
    }
}
