//
//  Network.swift
//  
//
//  Created by 최승민 on 1/31/25.
//

import Combine
import Foundation

public typealias QueryItems = [String: Any]
public typealias HTTPHeader = [String: String]

public protocol Request {
    associatedtype Output: Decodable

    var endpoint: URL { get }
    var method: HTTPMethod { get }
    var query: QueryItems { get }
    var header: HTTPHeader { get }
}

public protocol Network {
    func send<T: Request>(_ request: T) -> AnyPublisher<Response<T.Output>, Error>
    func put(key: HeaderKey, value: String?)
    func get(key: HeaderKey) -> String?
}

public struct Response<T: Decodable> {
    public let output: T
    public let statusCode: Int

    public init(output: T, statusCode: Int) {
        self.output = output
        self.statusCode = statusCode
    }
}

public enum HeaderKey: String {
    case authorization = "Authorization"
}
