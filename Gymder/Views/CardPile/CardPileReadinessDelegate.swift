//
//  CardPileReadinessDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import Foundation

protocol CardPileReadinessDelegate: AnyObject {
    func cardPileView(_ cardPileView: CardPileView, didChangeReadiness ready: Bool)
}
