//
//  URLSessionWrapper.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation

protocol URLSessionWrapperProtocol {
    func download(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class URLSessionWrapper: URLSessionWrapperProtocol {
    func download(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }

        task.resume()
    }
}
