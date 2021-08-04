//
//  CardPileDataSource.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

protocol CardPileDataSource: AnyObject {
    func next(completion: @escaping (Card?) -> Void)
}
