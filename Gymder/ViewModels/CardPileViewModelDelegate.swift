//
//  CardPileViewModelDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation

protocol CardPileViewModelDelegate: AnyObject {
    func update(error: GymRepositoryError?)
}
