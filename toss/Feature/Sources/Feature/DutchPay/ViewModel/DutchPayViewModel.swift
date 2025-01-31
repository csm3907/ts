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
    let dutchPayData = CurrentValueRelay<DutchPayModel?>(nil)
    let snapshot = CurrentValueRelay<DutchPaySnapshot?>(nil)
    
    init() {
        bindSnapshot()
    }
    
    // MARK: - Public Methods
    func fetchDutchPayData() {
        fetchUseCase.fetchDutchPayList()
            .sink { [weak self] completion in
                if case .failure(_) = completion {
                    self?.error.accept("client Error")
                }
            } receiveValue: { [weak self] model in
                self?.dutchPayData.accept(model)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func bindSnapshot() {
        dutchPayData
            .compactMap { $0 }
            .map { DutchPayMapper.mapToSnapshot(from: $0) }
            .sink { [weak self] snapshot in
                self?.snapshot.accept(snapshot)
            }
            .store(in: &cancellables)
    }
}
