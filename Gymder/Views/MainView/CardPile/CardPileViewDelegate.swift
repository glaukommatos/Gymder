//
//  CardPileViewDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import Foundation

protocol CardPileViewDelegate: AnyObject {
    func cardPileView(_ cardPileView: CardPileView, didChangeReadiness ready: Bool)
    func cardPileView(_ cardPileView: CardPileView, didChoose choice: CardPileChoice)
    func cardPileViewDidRunOutOfCards(_ cardPileView: CardPileView)
}
