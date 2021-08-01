//
//  CardPileChoiceDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

enum Choice {
    case accept
    case reject
}

protocol CardPileChoiceDelegate: AnyObject {
    func cardPile(_ cardPileView: CardPileView, didChoose choice: Choice)
}
