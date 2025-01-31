//
//  String+Extension.swift
//  Core
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

public extension String {
    func take(_ size: Int) -> String {
        return String(prefix(size))
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func url() -> URL {
        let urlText = trim()
        if let url = URL(string: urlText) {
            return url
        }
        if let urlString = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {
            return url
        }
        return URLComponents().url!
    }
}
