//
//  PayRepositoryImp.swift
//  Data
//
//  Created by 최승민 on 1/31/25.
//

import Core
import Domain

import Combine
import Foundation

public final class PayRepositoryImp: BaseRepository, PayRepository {
    private let baseURL: URL
    var cancellables: Set<AnyCancellable> = .init()

    public init(baseURL: URL, network: Network) {
        self.baseURL = baseURL
        super.init(network: network)
    }
}

public extension PayRepositoryImp {
    func fetchList(isFirst: Bool) -> AnyPublisher<DutchPayModel, Error> {
        if isFirst {
            return loadCachedData()
                .map { $0.toDomain() }
                .eraseToAnyPublisher()
        } else {
            let request = DutchPayListFetchRequest(baseURL)
            return send(request)
                .map { $0.output.toDomain() }
                .eraseToAnyPublisher()
        }
    }
    
    func request() {
        
    }
    
    private func loadCachedData() -> AnyPublisher<PayRequestItemDTO, Error> {
        Future { promise in
            if let url = Bundle.main.url(forResource: "cached_data", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let model = try? JSONDecoder().decode(PayRequestItemDTO.self, from: data) {
                promise(.success(model))
            } else {
                promise(.failure(NetworkError.invalidURL(url: "local url is not exist")))
            }
        }
        .eraseToAnyPublisher()
    }
}
