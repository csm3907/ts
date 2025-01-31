//
//  HTTPMethod.swift
//
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

public enum HTTPMethod: String, Encodable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
