//
//  DutchPayPresentationModel.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//
import Foundation

struct DutchHeaderModel {
    let date: String
    var completedAmount: Int
    var totalAmount: Int
    let message: String
}

struct DutchParticipantModel: Hashable {
    let id: Int
    let name: String
    let amount: Int
    var status: PaymentStatus
    let message: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DutchParticipantModel, rhs: DutchParticipantModel) -> Bool {
        return lhs.id == rhs.id
    }
}


