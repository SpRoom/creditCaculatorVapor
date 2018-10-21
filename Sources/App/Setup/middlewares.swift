//
//  middlewares.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor

public func setupMiddlewares(_ services: inout Services) throws {
    
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    ///middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(ThrowsMiddleware.self) //top level error register failure
    
    middlewares.use(ExceptionMiddleware(closure: { (req) -> (EventLoopFuture<Response>?) in
        let dict = ["code":"404","msg":"访问路径不存在"]
        return try dict.encode(for: req)
        //        return try req.view().render("leaf/loader").encode(for: req)
    }))
    
    
    try services.register(AuthProvider())
    
//    let auth = AuthMiddleware(authPath: "api/v1/users","api/v1/ticket","api/v1/upload")
//    middlewares.use(auth)
    
    let params = ParametersLogMiddleware()
    middlewares.use(params)
    
    // Serves files from `Public/` directory
    middlewares.use(FileMiddleware.self)
    
    // Session
    //    middlewares.use(SessionsMiddleware.self)
    
    services.register(middlewares)
}
