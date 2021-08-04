//
//  ChoiceBarDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import Foundation

protocol ChoiceBarDelegate: AnyObject {
    func choiceBar(_ choiceBar: ChoiceBarView, didChoose choice: CardPileChoice)
}
