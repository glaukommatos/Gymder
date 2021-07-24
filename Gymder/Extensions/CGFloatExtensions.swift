//
//  CGFloatExtensions.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import UIKit

extension CGFloat {
    init(radiansFrom degrees: CGFloat) {
        self.init(degrees * (CGFloat.pi / 180))
    }
}
