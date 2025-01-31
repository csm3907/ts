//
//  DutchPayViewModel.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import UIKit
import Domain
import Core

import Combine
import CombineExt

enum Keys {
    public static let requestingParticipantIds = "requestingParticipantIds"
    public static let requestStartTimes = "requestStartTimes"
}

final class DutchPayViewModel {
    // MARK: - Properties
    private let fetchUseCase: DutchPayFetchUseCase = .init()
    private var cancellables = Set<AnyCancellable>()
    
    let error = CurrentValueRelay<String?>(nil)
    let dutchPayData = CurrentValueRelay<DutchPayModel?>(nil)
    let snapshot = CurrentValueRelay<DutchPaySnapshot?>(nil)
    var requestingStartDates: [Int: Date?] = [:]
    
    @UserDefault(key: Keys.requestingParticipantIds, defaultValue: [])
    var requestingParticipantIds: [Int]
    
    init() {
        bind()
    }
    
    // MARK: - Public Methods
    func fetchDutchPayData() {
        fetchUseCase.fetchDutchPayList()
            .handleEvents(
                receiveOutput: { [weak self] model in
                    guard let self else { return }
                    
                    let updatedItems = model.dutchPayItems.map { item in
                        if self.requestingParticipantIds.contains(item.id) {
                            return DutchPayModel.DutchPayItemModel(
                                id: item.id,
                                name: item.name,
                                amount: item.amount,
                                transferMessage: item.transferMessage,
                                isDone: true,
                                isRequesting: true,
                                date: item.date
                            )
                        }
                        if let startDate = self.requestingStartDates[item.id] {
                            return DutchPayModel.DutchPayItemModel(
                                id: item.id,
                                name: item.name,
                                amount: item.amount,
                                transferMessage: item.transferMessage,
                                isDone: item.isDone,
                                isRequesting: true,
                                date: startDate
                            )
                        }
                        return item
                    }
                    
                    let updatedModel = DutchPayModel(
                        ownerName: model.ownerName,
                        message: model.message,
                        date: model.date,
                        totalAmount: model.totalAmount,
                        completedAmount: model.completedAmount,
                        dutchPayItems: updatedItems
                    )
                    self.dutchPayData.accept(updatedModel)
                    
                })
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error.accept("client Error")
                }
            } receiveValue: { _ in
                //self?.dutchPayData.accept(model)
            }
            .store(in: &cancellables)
    }
    
    func requestPayment(for participantId: Int) {
        let now = Date()
        requestingStartDates[participantId] = now
        updateStatus(participantId: participantId, isDone: false, isRequesting: true, startDate: now)
    }
    
    func requestPaymentDone(for participantId: Int) {
        requestingParticipantIds.append(participantId)
        requestingStartDates[participantId] = nil
        updateStatus(participantId: participantId, isDone: true, isRequesting: true)
    }
    
    func requestCancel(for participantId: Int) {
        requestingStartDates[participantId] = nil
        updateStatus(participantId: participantId, isDone: false, isRequesting: false)
    }
    
    // MARK: - Private Methods
    private func bind() {
        dutchPayData
            .compactMap { $0 }
            .map { DutchPayMapper.mapToSnapshot(from: $0) }
            .sink { [weak self] snapshot in
                self?.snapshot.accept(snapshot)
            }
            .store(in: &cancellables)
    }
    
    private func updateStatus(participantId: Int, isDone: Bool?, isRequesting: Bool?, startDate: Date? = nil) {
        guard let value = self.dutchPayData.value else { return }
        
        let updatedItems = value.dutchPayItems.map { item in
            if item.id == participantId {
                let updated = DutchPayModel.DutchPayItemModel(
                    id: item.id,
                    name: item.name,
                    amount: item.amount,
                    transferMessage: item.transferMessage,
                    isDone: isDone ?? item.isDone,
                    isRequesting: isRequesting ?? item.isRequesting,
                    date: startDate
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
