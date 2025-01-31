//
//  DutchPayMapper.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

import Domain

struct DutchPayMapper {
    func mapHeader(item: DutchPayModel) -> DutchHeaderModel {
        return DutchHeaderModel.init(
            date: item.date,
            completedAmount: item.completedAmount,
            totalAmount: item.totalAmount,
            message: item.message
        )
    }
    
    func mapItem(item: DutchPayModel) -> [DutchParticipantModel] {
        return item.dutchPayItems.map {
            DutchParticipantModel(
                id: $0.id,
                name: $0.name,
                amount: $0.amount,
                status: PaymentStatus.completed,
                message: $0.transferMessage
            )
        }
    }
}

extension DutchPayMapper {
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
        
        let participants = model.dutchPayItems.map { item in
            DutchPayItem.participant(
                DutchParticipantModel(
                    id: item.id,
                    name: item.name,
                    amount: item.amount,
                    status: item.isDone ? .completed : .requested,
                    message: item.transferMessage
                )
            )
        }
        snapshot.appendItems(participants, toSection: .main)
        
        return snapshot
    }
}
