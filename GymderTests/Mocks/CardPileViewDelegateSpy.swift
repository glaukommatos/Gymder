//
//  CardPileViewDelegateSpy.swift
//  GymderTests
//
//  Created by Kyle Pointer on 30.07.21.
//

import Foundation
@testable import Gymder

class CardPileViewDelegateSpy: CardPileViewDelegate {
    var lastChoice: CardPileChoice?
    var didChangeReadyness: Bool?
    var didRunOutOfCards = false

    func cardPileView(_ cardPileView: CardPileView, didChangeReadiness ready: Bool) {
        didChangeReadyness = ready
    }

    func cardPileView(_ cardPileView: CardPileView, didChoose choice: CardPileChoice) {
        lastChoice = choice
    }

    func cardPileViewDidRunOutOfCards(_ cardPileView: CardPileView) {
        didRunOutOfCards = true
    }
}
