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
    var serialQueue = DispatchQueue(label: "MockCardDataSource-serialQueue")

    func next(completion: @escaping (Card?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.serialQueue.sync {
                completion(self.cards.popLast())
            }
        }
    }
}
