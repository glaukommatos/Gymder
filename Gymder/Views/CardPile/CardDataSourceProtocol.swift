//
//  CardDataSourceProtocol.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

protocol CardDataSourceProtocol: AnyObject {
    func next() -> Card?
}
