//
//  ChoiceBarDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import Foundation

protocol ChoiceBarDelegate: AnyObject {
    func accept(choiceBar: ChoiceBar)
    func reject(choiceBar: ChoiceBar)
}
