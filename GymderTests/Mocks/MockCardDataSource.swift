//
//  MockCardDataSource.swift
//  GymderTests
//
//  Created by Kyle Pointer on 30.07.21.
//

import Foundation
@testable import Gymder

class MockCardDataSource: CardPileDataSource {
    var cards = [Card]()

    func next(completion: @escaping (Card?) -> Void) {
        completion(cards.popLast())
    }
}
