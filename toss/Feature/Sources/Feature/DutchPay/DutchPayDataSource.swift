//
//  DutchPayDataSource.swift
//  Feature
//
//  Created by 최승민 on 1/31/25.
//

import Domain

import UIKit

typealias DutchPayDataSource = UITableViewDiffableDataSource<DutchPaySection, DutchPayItem>
typealias DutchPaySnapshot = NSDiffableDataSourceSnapshot<DutchPaySection, DutchPayItem>

// MARK: - Enum & Model
public enum DutchPaySection {
    case header
    case main
}

public enum DutchPayItem: Hashable {
    case header(DutchPayHeaderInfo)
    case participant(DutchPayParticipant)
}

public struct DutchPayHeaderInfo: Hashable {
    let id = UUID()
}

public struct DutchPayParticipant: Hashable {
    let id = UUID()
    let name: String
    let amount: Int
    let status: PaymentStatus
    let message: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: DutchPayParticipant, rhs: DutchPayParticipant) -> Bool {
        return lhs.id == rhs.id
    }
}

enum PaymentStatus: String {
    case completed = "완료"
    case requested = "요청함"
}
