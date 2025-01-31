//
//  DutchPayMapper.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

import Domain

struct DutchPayMapper {
    static func mapToSnapshot(from model: DutchPayModel) -> DutchPaySnapshot {
        var snapshot = DutchPaySnapshot()
        snapshot.appendSections([.header, .main])
        
        let headerItem = DutchHeaderModel(
            date: model.date,
            completedAmount: model.completedAmount,
            totalAmount: model.totalAmount,
            message: "\(model.ownerName): \(model.message)"
        )
        snapshot.appendItems([.header(headerItem)], toSection: .header)
        
        var participants = model.dutchPayItems.map { item in
            var status: PaymentStatus
            if item.isDone {
                if item.isRequesting {
                    status = .requested
                } else {
                    status = .completed
                }
            } else {
                if item.isRequesting {
                    status = .requesting
                } else {
                    status = .reRequest
                }
            }
            
            return DutchPayItem.participant(
                DutchParticipantModel(
                    id: item.id,
                    name: item.name,
                    amount: item.amount,
                    status: status,
                    message: item.transferMessage
                )
            )
        }
        let half = model.dutchPayItems.count / 2
        participants.insert(.commercial("토스 공동계좌를 개설해 보세요"), at: half)
        
        snapshot.appendItems(participants, toSection: .main)
        
        return snapshot
    }
}
