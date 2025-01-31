//
//  DutchPayListFetchRequest.swift
//  Data
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

import Core
import Domain

import Foundation

struct DutchPayListFetchRequest: Request {
    typealias Output = DutchPayRequestItemDTO

    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader

    init(_ url: URL) {
        endpoint = url.appendingPathComponent("/toss_ios_homework_dutch_detail")
        method = .get
        let params: [String: Any] = [:]
        query = params
        header = [:]
    }
}
