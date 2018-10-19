//
//  SessionAuthMiddleware.swift
//  App
//
//  Created by spectator Mr.Z on 2018/9/28.
//

import Vapor
import FluentMySQL

public final class SessionAuthMiddleware: Middleware {
    
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        
        let auth = try checkUser(request)
        
        if auth {
            return try next.respond(to: request)
        }
        
        let resp = try request.redirect(to: "login").encode(for: request)
        
       return resp
    }
    
    public func checkUser(_ req: Request) throws -> Bool {
        
//      let id = try req.isAuthenticated(User.self)
//        return id
        
        if let user = try req.session()["user"] {
            return true
        }
        return false
    }
    
    
}
