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
    
    func requestPayment(for participantId: Int) {
        updateStatus(participantId: participantId, isDone: false, isRequesting: true)
    }
    
    func requestPaymentDone(for participantId: Int) {
        updateStatus(participantId: participantId, isDone: true, isRequesting: true)
    }
    
    func requestCancel(for participantId: Int) {
        updateStatus(participantId: participantId, isDone: false, isRequesting: false)
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
    
    private func updateStatus(participantId: Int, isDone: Bool?, isRequesting: Bool?) {
        guard let value = self.dutchPayData.value else { return }
        
        let updatedItems = value.dutchPayItems.map { item in
            if item.id == participantId {
                let updated = DutchPayModel.DutchPayItemModel(
                    id: item.id,
                    name: item.name,
                    amount: item.amount,
                    transferMessage: item.transferMessage,
                    isDone: isDone ?? item.isDone,
                    isRequesting: isRequesting ?? item.isRequesting
                )
                return updated
            }
            return item
        }
        
        let updatedModel = DutchPayModel(
            ownerName: value.ownerName,
            message: value.message,
            date: value.date,
            totalAmount: value.totalAmount,
            completedAmount: value.completedAmount,
            dutchPayItems: updatedItems
        )
        
        dutchPayData.accept(updatedModel)
    }
}
