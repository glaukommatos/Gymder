//
//  GymService.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation
import CoreLocation

class GymService: GymServiceProtocol {
    let urlSessionWrapper: URLSessionWrapperProtocol
    let partnersResponseMapper: PartnersResponseMapperProtocol
    let apiUrl = URL(string: "https://api.one.fit/v2/en-nl/partners/city/UTR")!

    var jsonDecoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    init(urlSessionWrapper: URLSessionWrapperProtocol,
         partnersResponseMapper: PartnersResponseMapperProtocol) {
        self.urlSessionWrapper = urlSessionWrapper
        self.partnersResponseMapper = partnersResponseMapper
    }

    func getGyms(completion: @escaping ([Gym]?) -> Void) {
        var request = URLRequest(url: apiUrl)
        request.setValue("OneFit/1.19.0", forHTTPHeaderField: "User-Agent")

        urlSessionWrapper.download(request: request) { data, _, _ in
            if  let data = data,
                let partnersResponse = try? self.jsonDecoder.decode(PartnersResponse.self, from: data) {
                completion(self.partnersResponseMapper.map(response: partnersResponse))
            } else {
                completion(nil)
            }
        }
    }
}
