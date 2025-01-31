//
//  DutchPayRequestItemDTO.swift
//  Data
//
//  Created by 최승민 on 1/31/25.
//

import Foundation
import Domain

public struct DutchPayRequestItemDTO: Codable {
    var dutchSummary: DutchSummaryDTO?
    var dutchDetailList: [DutchDetailListItemDTO]?
    
    func toDomain() -> DutchPayModel {
        return DutchPayModel.init(
            ownerName: dutchSummary?.ownerName ?? "",
            message: dutchSummary?.message ?? "",
            date: dutchSummary?.date ?? "",
            totalAmount: dutchSummary?.totalAmount ?? 0,
            completedAmount: dutchSummary?.completedAmount ?? 0,
            dutchPayItem: dutchDetailList?.map { $0.toDomain() } ?? []
        )
    }
}

public struct DutchDetailListItemDTO: Codable {
    let dutchID: Int?
    let name: String?
    let amount: Int?
    let transferMessage: String?
    let isDone: Bool?
    let isRequesting: Bool?
    
    public func toDomain() -> DutchPayModel.DutchPayItemModel {
        return DutchPayModel.DutchPayItemModel.init(
            id: dutchID ?? 0,
            name: name ?? "",
            amount: amount ?? 0,
            transferMessage: transferMessage ?? "",
            isDone: isDone ?? false,
            isRequesting: isRequesting ?? false
        )
    }
}

public struct DutchSummaryDTO: Codable {
    let ownerName, message: String?
    let ownerAmount, completedAmount, totalAmount: Int?
    let date: String?
}
