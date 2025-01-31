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
enum DutchPaySection {
    case header
    case main
}

enum DutchPayItem: Hashable {
    case header(DutchHeaderModel)
    case participant(DutchParticipantModel)
    case commercial(String)
}
