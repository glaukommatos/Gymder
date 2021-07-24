//
//  MockURLSessionWrapper.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation
@testable import Gymder

enum MockURLSessionWrapperError: Error {
    case noResponseMatchingRequest
}

class MockURLSessionWrapper: URLSessionWrapperProtocol {
    let requests: [URLRequest:(Data?, URLResponse?, Error?)]

    init(requests: [URLRequest:(Data?, URLResponse?, Error?)]) {
        self.requests = requests
    }

    func download(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let responseInfo = requests[request] {
            completion(responseInfo.0, responseInfo.1, responseInfo.2)
        } else {
            completion(nil, nil, MockURLSessionWrapperError.noResponseMatchingRequest)
        }
    }
}
