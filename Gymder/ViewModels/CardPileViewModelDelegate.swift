//
//  CardPileViewModelDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation

/**

 Implement this if you'd like to listen to updates from the
 `CardPileViewModel`.

 */

protocol CardPileViewModelDelegate: AnyObject {
    func update(error: GymRepositoryError?)
}
