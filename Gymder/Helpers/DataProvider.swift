//
//  DataProvider.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation

class DataProvider: DataProviderProtocol {
    func download(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        download(url: url, withUserAgent: nil, completion: completion)
    }

    func download(url: URL, withUserAgent userAgent: String?, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlRequest = URLRequest(url: url)

        if let userAgent = userAgent {
            urlRequest.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(Result.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data else {
                completion(Result.failure(DataProviderError.badResponseFromServer))
                return
            }

            completion(Result.success(data))
        }.resume()
    }
}
