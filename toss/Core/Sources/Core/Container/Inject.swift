//
//  Inject.swift
//  Core
//
//  Created by 최승민 on 1/31/25.
//

import Foundation

@propertyWrapper
public struct Inject<Value> {
    public private(set) var wrappedValue: Value
    private let container = Container.shared

    public init() {
        guard let value = container.resolve(Value.self) else {
            fatalError("Could not resolve non-optional \(Value.self)")
        }
        wrappedValue = value
    }

    public init(id: Int) {
        guard let value = container.resolve(Value.self, argument: id) else {
            fatalError("Could not resolve non-optional \(Value.self)")
        }
        wrappedValue = value
    }

    public init<Wrapped>(name: String? = nil) where Value == Optional<Wrapped> {
        wrappedValue = container.resolve(Wrapped.self)
    }
}
