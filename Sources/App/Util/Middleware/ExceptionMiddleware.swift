//
//  ExceptionMiddleware.swift
//  App
//
//  Created by Jinxiansen on 2018/6/14.
//

import Foundation
import Vapor

//路由异常处理。
public final class ExceptionMiddleware: Middleware,Service {

    private let closure: (Request) throws -> (Future<Response>?)

    init(closure: @escaping (Request) throws -> (Future<Response>?)) {
        self.closure = closure
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        return try next.respond(to: request).flatMap({ (resp) in
            
            let status = resp.http.status
            if status == .notFound { //拦截 404，block回调处理。
                if let resp = try self.closure(request) {
                    return resp
                }
            }
            return request.eventLoop.newSucceededFuture(result: resp)
        })
    }
    
}







