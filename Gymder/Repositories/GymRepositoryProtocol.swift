//
//  GymRepositoryProtocol.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation

enum GymRepositoryError: Error {
    case failure
}

protocol GymRepositoryProtocol {
    func getGyms(completion: @escaping (Result<[Gym], GymRepositoryError>) -> Void)
}
