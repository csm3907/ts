//
//  Int+Extension.swift
//  Core
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

public extension Int {
    var formattedWithComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
