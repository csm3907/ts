//
//  DutchPayPresentationModel.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//
import Foundation

struct DutchHeaderModel: Hashable {
    let id = UUID()
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
    var date: Date?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(status)
    }
    
    static func == (lhs: DutchParticipantModel, rhs: DutchParticipantModel) -> Bool {
        return (lhs.id == rhs.id) && (lhs.status == rhs.status)
    }
}

enum PaymentStatus: String {
    case completed = "완료"
    case requested = "요청함"
    case requesting = "요청중"
    case reRequest = "재요청"
    
    init?(value: String) {
        if let type = PaymentStatus(rawValue: value) {
            self = type
        } else {
            return nil
        }
    }
}

