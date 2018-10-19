//
//  ParametersLogMiddleware.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/22.
//

import Vapor


public struct ParametersLogMiddleware : Middleware {
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        
        let logger = try request.make(Logger.self)
        
        logger.debug( "\(Date()) ----- "+request.description)
        
        return try next.respond(to: request)
    }
}
