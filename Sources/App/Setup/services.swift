//
//  services.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor
import FluentMySQL
import Authentication

public func registerProvider(_ services: inout Services, _ config: inout Config) throws {
    
    try services.register(FluentMySQLProvider())
    
    services.register(ThrowsMiddleware.self)
    
    try services.register(AuthenticationProvider())
    
   
    
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
