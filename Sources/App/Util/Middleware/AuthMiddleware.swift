//
//  AuthMiddleware.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/24.
//

import Vapor
import FluentMySQL

public final class AuthMiddleware: Middleware {
    
    private let authProviders : [String]
    
    init(authPath: String...) {
        self.authProviders = authPath
    }
    
    
    enum TokenAuthResult {
        case success(tk: String)
        case null
        case expire
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        
        let logger = try request.make(Logger.self)
        
        let path = request.http.urlString
        let method = request.http.method
        
        logger.debug("path -- \(path)  method -- \(method)")

        for aPath in authProviders {
            
            if path.contains(aPath) {
                let result = try checkToken(request)
                
             return   result.flatMap { (tokenRs)  in
                    switch tokenRs {
                    case .success(let userID):
                        
                       return User.query(on: request).filter(\.userID == userID).first().flatMap({ (user) in
                            if let u = user {
                                try request.auth(u)
                                return try next.respond(to: request)
                            }
                            let vo = ResponseJSON<Empty>(status: ResponseCode.tokenNotExist)
                            return try VaporResponseUtil.makeResponse(req: request, vo: vo)
                        })
                        
//                      return  UserInfo.query(on: request).filter(\.userID == userID).first().flatMap({ (userinfo)  in
//                            if let u = userinfo {
//                                try request.auth(u)
//                                return try next.respond(to: request)
//                            }
//                            let vo = ResponseVO<Empty>(status: ResponseCode.tokenNotExist)
//                            return try VaporResponseUtil.makeResponse(req: request, vo: vo)
//
//                        })
                        
//                        return try next.respond(to: request)
                    case .null:
                        let vo = ResponseJSON<Empty>(status: ResponseCode.tokenNotExist)
                        return try VaporResponseUtil.makeResponse(req: request, vo: vo)
                    case .expire:
                        let vo = ResponseJSON<Empty>(status: ResponseCode.tokenExpire)
                        return try VaporResponseUtil.makeResponse(req: request, vo: vo)
                    }
                }

            }
        }

        return try next.respond(to: request)
    }
    
    
    func checkToken(_ req: Request) throws -> Future<TokenAuthResult> {
        
        if let token = req.http.headers["X-AUTH-TOKEN"].first {
            
            let bearToken = BearerAuthorization(token: token)
            
            let auth = AccessToken.authenticate(using: bearToken, on: req)
            let result = auth.map { (tk) -> TokenAuthResult in
                if let tk = tk {
                    
                    let obj = TokenAuthResult.success(tk: tk.userID)
                    return obj
//                    return .success(tk: token)
                                } else {
                                    return .expire
                                }
            }
            
            return result
        
        } else {
            
         let obj = Future.map(on: req) {
                return TokenAuthResult.null
            }
            return obj
//            return .null
        }
        
    }
    
}
