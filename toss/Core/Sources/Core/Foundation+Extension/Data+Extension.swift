//
//  Untitled.swift
//  Core
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

public extension Data {
    var prettyPrintedJSONString: String? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []) else {
           return nil
        }
        if let prettyPrintedData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
           return(String(bytes: prettyPrintedData, encoding: .utf8) ?? "nil")
        }
        return nil
    }
}
