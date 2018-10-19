//
//  AuthTool.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/28.
//

import Foundation
import Vapor

public protocol AuthContent {}

public final class AuthProvider : Provider {
    
    public init() {}
    
    public func register(_ services: inout Services) throws {
        services.register { container in
            return AuthCache()
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    
}

final class AuthCache: Service {
    /// The internal storage.
    private var storage: [ObjectIdentifier: Any]
    
    /// Create a new authentication cache.
    init() {
        self.storage = [:]
    }
    
    /// Access the cache using types.
    internal subscript<A>(_ type: A.Type) -> A?
        where A: AuthContent
        {
        get { return storage[ObjectIdentifier(A.self)] as? A }
        set { storage[ObjectIdentifier(A.self)] = newValue }
    }
}


extension Request {
    
    public func auth<A>(_ instance: A) throws where A : AuthContent {
        let cache = try privateContainer.make(AuthCache.self)
        cache[A.self] = instance
    }
    
    public func authed<A>(_ type: A.Type = A.self) throws -> A? where A : AuthContent {
        let cache = try privateContainer.make(AuthCache.self)
        return cache[A.self]
    }
    
//    public func authed<A>(_ type: A.Type) throws -> A where A: AuthContent {
//        let cache = try privateContainer.make(AuthCache.self)
//        return cache[A.self] 
//    }
    
}
