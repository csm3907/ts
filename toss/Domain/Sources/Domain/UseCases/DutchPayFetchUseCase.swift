//
//  DutchPayFetchUseCase.swift
//  Domain
//
//  Created by 최승민 on 1/31/25.
//

import Core

import Combine
import Foundation

public class DutchPayFetchUseCase {
    @Inject private var payRepository: PayRepository

    public init() {}
}

public extension DutchPayFetchUseCase {
    func fetchDutchPayList() -> AnyPublisher<DutchPayModel, Error> {
        return payRepository.fetchList()
    }
}
