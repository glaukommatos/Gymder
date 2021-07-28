//
//  GymService.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import Foundation
import CoreLocation
import Combine

/**
    Grabs the "partners" from the API and maps them into
    `Gym`s.

    Decided to have this return `Result`s because I think
    it's kidna nice. In the future they play really well with
    Combine, which sadly doesn't have nearly as many
    fancy `Publisher`s when I'm targetting iOS 11.

 */

struct GymRepository: GymRepositoryProtocol {
    let dataProvider: DataProviderProtocol
    let partnersResponseMapper: PartnersResponseMapperProtocol
    let apiUrl = URL(string: "https://api.one.fit/v2/en-nl/partners/city/UTR")!

    init(
        urlSessionWrapper: DataProviderProtocol,
        partnersResponseMapper: PartnersResponseMapperProtocol
    ) {
        self.dataProvider = urlSessionWrapper
        self.partnersResponseMapper = partnersResponseMapper
    }

    func getGyms(completion: @escaping (Result<[Gym], GymRepositoryError>) -> Void) {
        dataProvider.download(url: apiUrl, withUserAgent: "OneFit/1.19.0") { result in
            switch result {
            case .success(let data):
                if let partnersResponse = try? Serialization.decoder.decode(PartnersResponse.self, from: data) {
                    completion(.success(partnersResponseMapper.map(response: partnersResponse)))
                } else {
                    completion(.failure(.failure))
                }
            case .failure:
                completion(.failure(.failure))
            }
        }
    }
}
