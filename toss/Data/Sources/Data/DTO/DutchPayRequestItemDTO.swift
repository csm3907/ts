//
//  DutchPayRequestItemDTO.swift
//  Data
//
//  Created by 최승민 on 1/31/25.
//

import Foundation
import Domain

public struct PayRequestItemDTO: Codable {
    var dutchSummary: PaySummaryDTO?
    var dutchDetailList: [PayDetailListItemDTO]?
    
    func toDomain() -> DutchPayModel {
        return DutchPayModel.init(
            ownerName: dutchSummary?.ownerName ?? "",
            message: dutchSummary?.message ?? "",
            date: dutchSummary?.date ?? "",
            totalAmount: dutchSummary?.totalAmount ?? 0,
            completedAmount: dutchSummary?.completedAmount ?? 0,
            dutchPayItems: dutchDetailList?.map { $0.toDomain() } ?? []
        )
    }
}

public struct PayDetailListItemDTO: Codable {
    let dutchId: Int?
    let name: String?
    let amount: Int?
    let transferMessage: String?
    let isDone: Bool?
    let isRequesting: Bool?
    
    public func toDomain() -> DutchPayModel.DutchPayItemModel {
        return DutchPayModel.DutchPayItemModel.init(
            id: dutchId ?? 0,
            name: name ?? "",
            amount: amount ?? 0,
            transferMessage: transferMessage ?? "",
            isDone: isDone ?? false,
            isRequesting: isRequesting ?? false
        )
    }
}

public struct PaySummaryDTO: Codable {
    let ownerName, message: String?
    let ownerAmount, completedAmount, totalAmount: Int?
    let date: String?
}
