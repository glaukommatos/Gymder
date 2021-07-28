//
//  CardDataSourceProtocol.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

/**

    If you'd like to use the `CardPileView` for something else,
    you can implement this protocol to do so.

    Currently, the `CardPileViewModel` implements this.

 */

protocol CardDataSourceProtocol: AnyObject {
    func next() -> Card?
}
