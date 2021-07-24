//
//  GymServiceProtocol.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

protocol GymServiceProtocol {
    func getGyms(completion: @escaping ([Gym]?) -> Void)
}
