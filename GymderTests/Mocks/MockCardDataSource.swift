//
//  MockCardDataSource.swift
//  GymderTests
//
//  Created by Kyle Pointer on 30.07.21.
//

import Foundation
@testable import Gymder

class MockCardDataSource: CardDataSourceProtocol {
    var cards = [Card]()
    var cardsLock = NSLock()

    func next(completion: @escaping (Card?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.cardsLock.lock()
            completion(self.cards.popLast())
            self.cardsLock.unlock()
        }
    }
}
