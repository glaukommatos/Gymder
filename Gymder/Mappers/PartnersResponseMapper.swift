//
//  PartnersResponseMapper.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation
import CoreLocation
import UIKit

/**

 It would probably still be good to remove the UIKit code here and inject the screen width in another way
 for better testability and separation of concerns.

 */

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
                    imageUrl: imageUrlForDeviceSize(headerImage: partner.headerImage))
            }
        }
    }

    private func imageUrlForDeviceSize(headerImage: PartnersResponse.Data.Image) -> URL {
        guard let screenWidth = UIScreen.main.currentMode?.size.width else {
            // I really think this shouldn't happen. (Unless maybe in a unit test that isn't
            // hosted by the actual app).
            return headerImage.hdpi
        }

        let pixelsWide = Int(screenWidth)
        switch pixelsWide {
        case 0...540:
            return headerImage.hdpi
        case 541...720:
            return headerImage.xhdpi
        case 721...1080:
            return headerImage.xxhdpi
        case 1081...1440:
            return headerImage.xxxhdpi
        default:
            return headerImage.desktop
        }
    }
}
