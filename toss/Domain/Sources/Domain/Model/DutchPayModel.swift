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
    
    public let dutchPayItems: [DutchPayItemModel]
    
    public struct DutchPayItemModel {
        public let id: Int
        public let name: String
        public let amount: Int
        public let transferMessage: String?
        public let isDone: Bool
        public let isRequesting: Bool
        public let date: Date?
        
        public init(id: Int, name: String, amount: Int, transferMessage: String?, isDone: Bool, isRequesting: Bool, date: Date? = nil) {
            self.id = id
            self.name = name
            self.amount = amount
            self.transferMessage = transferMessage
            self.isDone = isDone
            self.isRequesting = isRequesting
            self.date = date
        }
    }
    
    public init(ownerName: String, message: String, date: String, totalAmount: Int, completedAmount: Int, dutchPayItems: [DutchPayItemModel]) {
        self.ownerName = ownerName
        self.message = message
        self.date = date
        self.totalAmount = totalAmount
        self.completedAmount = completedAmount
        self.dutchPayItems = dutchPayItems
    }
}
