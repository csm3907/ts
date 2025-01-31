//
//  NetworkImp.swift
//
//
//  Created by 최승민 on 1/31/25.
//

import Foundation
import Combine

struct ErrorResponseDTO: Codable {
    let message: String
}

public final class NetworkImp: Network {
    private var defaultHeaders: HTTPHeader = [:]
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
        session.configuration.timeoutIntervalForRequest = 30
    }
    
    public func send<T>(_ request: T) -> AnyPublisher<Response<T.Output>, any Error> where T : Request {
        do {
            let defaultHeader = defaultHeaders
            
            var urlRequest = try RequestFactory(request: request).urlRequestRepresentation()
            
            for header in defaultHeaders {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
            
            return session.dataTaskPublisher(for: urlRequest)
                .handleEvents( receiveOutput: { data, response in
                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
                    
                    let status = statusCode / 100 == 2 ? "Success" : "Failure"
                    let dataString = data.prettyPrintedJSONString ?? ""
                    let message = """
                    \n\(status) \(urlRequest.httpMethod ?? "") \(request.endpoint) (\(statusCode))
                    DEFAULT: \(defaultHeader))
                    HEADER: \(request.header))
                    QUERY: \(request.query))
                    \(dataString)
                    """
                    print(message)
                })
                .tryMap { data, response in
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    guard statusCode / 100 == 2 else {
                        let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data)
                        throw NSError(domain: response.description, code: statusCode, userInfo: ["data": errorResponse?.message ?? ""])
                    }
                    if data.isEmpty {
                        let emptyData = "{}".data(using: .utf8)
                        let output = try JSONDecoder().decode(T.Output.self, from: emptyData ?? data)
                        return Response(output: output, statusCode: statusCode)
                    } else {
                        let output = try JSONDecoder().decode(T.Output.self, from: data)
                        return Response(output: output, statusCode: statusCode)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    public func put(key: HeaderKey, value: String?) {
        defaultHeaders[key.rawValue] = value
    }
    
    public func get(key: HeaderKey) -> String? {
        return defaultHeaders[key.rawValue]
    }
}


private final class RequestFactory<T: Request> {
    let request: T
    private var urlComponents: URLComponents?

    init(request: T) {
        self.request = request
        urlComponents = URLComponents(url: request.endpoint, resolvingAgainstBaseURL: true)
    }

    func urlRequestRepresentation() throws -> URLRequest {
        switch request.method {
        case .get, .delete:
            return try makeURLRequest()
        case .post, .put, .patch:
            return try makeBodyRequest()
        }
    }

    private func makeURLRequest() throws -> URLRequest {
        if request.query.isEmpty == false {
            urlComponents?.queryItems = request.query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        return try makeRequest()
    }

    private func makeBodyRequest() throws -> URLRequest {
        let body = try JSONSerialization.data(withJSONObject: request.query, options: [])
        return try makeRequest(httpBody: body)
    }

    private func makeRequest(httpBody: Data? = nil) throws -> URLRequest {
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL(url: request.endpoint.absoluteString)
        }

        var urlRequest = URLRequest(url: url)
        request.header.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = httpBody
        urlRequest.timeoutInterval = 15

        if httpBody != nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }
}
