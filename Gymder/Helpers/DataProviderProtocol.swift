//
//  DataProviderProtocol.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation

protocol DataProviderProtocol {
    func download(url: URL, withUserAgent userAgent: String?, completion: @escaping (Result<Data, Error>) -> Void)
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

enum DataProviderError: Error {
    case badResponseFromServer
}
