//
//  Serialization.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation

/**

 Convenience so that we can be consistent about JSON serialization/deserialization.

 Right now it returns a new encoder/decoder each time. I'm honestly not sure at the
 moment if these these two are thread-safe, so I want to make sure if they aren't that
 consumers are at least getting their own instances– and I think these are cheap enough
 to make. :)

 */

struct Serialization {
    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
