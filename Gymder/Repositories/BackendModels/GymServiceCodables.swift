//
//  PartnersResponse.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

/**

    At some point I'll read the docs for `Codable` and
    figure out how to get avoid that extra layer of nesting
    for root elements like `data`, but I haven't done so
    yet.

    I'm not 100% sure how I feel about nesting the types
    like this. It's a little tedious to have to refer to them by
    their more fully qualified names, BUT it's also really nice
    that I can name them more freely and they aren't showing
    up in my autocomplete all the time. :)

 */

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
