//
//  CardChoiceSpy.swift
//  GymderTests
//
//  Created by Kyle Pointer on 30.07.21.
//

import Foundation
@testable import Gymder

class CardChoiceSpy: CardPileChoiceDelegate {
    var lastChoice: Choice?

    func cardPile(_ cardPileView: CardPileView, didChoose choice: Choice) {
        lastChoice = choice
    }
}
