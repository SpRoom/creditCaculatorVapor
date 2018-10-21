//
//  routers.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Vapor

public func routers(_ services: inout Services) throws {
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
}


/// Register your application's routes here.
fileprivate func routes(_ router: Router) throws {
    

    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    try router.register(collection: UserActionController())
    try router.register(collection: BillController())
    try router.register(collection: AccountController())
    try router.register(collection: LoanController())
}
