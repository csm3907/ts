//
//  NetworkError.swift
//
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL(url: String)
    case invalidHTTPResponse(response: URLResponse)
    case decodingError(description: String, data: Data)
    case tokenExpired
    case systemMaintenance
    case unknown
}
