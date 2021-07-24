//
//  CardDataSource.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

protocol CardDataSource: AnyObject {
    func next() -> Card?
    func load()

    var cardPileView: CardPileView? { get set }
}
