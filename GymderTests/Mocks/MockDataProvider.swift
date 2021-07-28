//
//  MockDataProvider.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation
@testable import Gymder

struct MockDataRequest: Hashable {
    let url: URL
    let userAgent: String?
}

enum MockDataProviderError: Error {
    case noSetupForRequest
}

struct MockDataProvider: DataProviderProtocol {
    let setupRequests: [MockDataRequest: Data]

    func download(url: URL, withUserAgent userAgent: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        let mockDataRequest = MockDataRequest(url: url, userAgent: userAgent)
        if let data = setupRequests[mockDataRequest] {
            completion(.success(data))
        } else {
            completion(.failure(MockDataProviderError.noSetupForRequest))
        }
    }

    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        download(url: url, withUserAgent: nil, completion: completion)
    }
}
