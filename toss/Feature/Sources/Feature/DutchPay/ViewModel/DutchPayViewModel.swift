//
//  DutchPayViewModel.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import Foundation
import Domain

import Combine
import CombineExt

final class DutchPayViewModel {
    // MARK: - Properties
    private let fetchUseCase: DutchPayFetchUseCase = .init()
    private var cancellables = Set<AnyCancellable>()
    
    let error = CurrentValueRelay<String?>(nil)
    
    // MARK: - Public Methods
    func fetchDutchPayData() {
        fetchUseCase.fetchDutchPayList()
            .sink { completion in
                
            } receiveValue: { model in
                print("Data 가져오기 : \(model)")
            }
            .store(in: &cancellables)
    }
}
