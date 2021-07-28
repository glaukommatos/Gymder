//
//  CardChoiceDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

/**

    Originally implemented this with `accept()` and
    `reject()`, but I removed reject because I didn't
    do anything with it, and also I know that rejection hurts.

 */

protocol CardChoiceDelegate: AnyObject {
    func accept()
}
