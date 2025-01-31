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
    func fetchList() -> AnyPublisher<DutchPayModel, Error> {
        let request = DutchPayListFetchRequest(baseURL)
        return send(request)
            .map { $0.output.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func request() {
        
    }
}
