//
//  PayRepository.swift
//  Domain
//
//  Created by 최승민 on 1/31/25.
//

import Combine
import Foundation

public protocol PayRepository {
    func fetchList(isFirst: Bool) -> AnyPublisher<DutchPayModel, Error>
    func request()
}
