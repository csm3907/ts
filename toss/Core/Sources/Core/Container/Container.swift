//
//  Container.swift
//  Core
//
//  Created by 최승민 on 1/31/25.
//

import Foundation
import Swinject

public enum Scope {
    case single
    case factory

    var swinjectScope: ObjectScope {
        switch self {
        case .single: return .container
        case .factory: return .graph
        }
    }
}

public class Container {
    public static let shared = Container()
    private let _container = Swinject.Container()
}

public extension Container {
    func register<Service>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    func register<Service, Arg1>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver, Arg1) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    func register<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver, Arg1, Arg2) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    func register<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver, Arg1, Arg2, Arg3) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    func register<Service, Arg1, Arg2, Arg3, Arg4>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver, Arg1, Arg2, Arg3, Arg4) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    func register<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver, Arg1, Arg2, Arg3, Arg4, Arg5) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    func register<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(
        _ serviceType: Service.Type,
        scope: Scope = .factory,
        factory: @escaping (Swinject.Resolver, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6) -> Service
    ) {
        _container.register(serviceType.self, factory: factory)
            .inObjectScope(scope.swinjectScope)
    }

    // MARK: - Resolve

    func resolve<Service>(
        _ serviceType: Service.Type
    ) -> Service? {
        _container.resolve(serviceType.self)
    }

    func resolve<Service, Arg1>(
        _ serviceType: Service.Type,
        argument: Arg1
    ) -> Service? {
        _container.resolve(serviceType.self, argument: argument)
    }

    func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2
    ) -> Service? {
        _container.resolve(serviceType.self, arguments: arg1, arg2)
    }

    func resolve<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3
    ) -> Service? {
        _container.resolve(serviceType.self, arguments: arg1, arg2, arg3)
    }

    func resolve<Service, Arg1, Arg2, Arg3, Arg4>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4
    ) -> Service? {
        _container.resolve(serviceType.self, arguments: arg1, arg2, arg3, arg4)
    }

    func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5
    ) -> Service? {
        _container.resolve(serviceType.self, arguments: arg1, arg2, arg3, arg4, arg5)
    }

    func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6
    ) -> Service? {
        _container.resolve(serviceType.self, arguments: arg1, arg2, arg3, arg4, arg5, arg6)
    }
}
