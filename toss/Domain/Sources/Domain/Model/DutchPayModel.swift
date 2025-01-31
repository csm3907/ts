//
//  DutchPayModel.swift
//  Domain
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

public struct DutchPayModel {
    public let ownerName: String
    public let message: String
    public let date: String
    public let totalAmount: Int
    public let completedAmount: Int
    
    public let dutchPayItem: [DutchPayItemModel]
    
    public struct DutchPayItemModel {
        let id: Int
        let name: String
        let amount: Int
        let transferMessage: String?
        let isDone: Bool
        let isRequesting: Bool
        
        public init(id: Int, name: String, amount: Int, transferMessage: String?, isDone: Bool, isRequesting: Bool) {
            self.id = id
            self.name = name
            self.amount = amount
            self.transferMessage = transferMessage
            self.isDone = isDone
            self.isRequesting = isRequesting
        }
    }
    
    public init(ownerName: String, message: String, date: String, totalAmount: Int, completedAmount: Int, dutchPayItem: [DutchPayItemModel]) {
        self.ownerName = ownerName
        self.message = message
        self.date = date
        self.totalAmount = totalAmount
        self.completedAmount = completedAmount
        self.dutchPayItem = dutchPayItem
    }
}
