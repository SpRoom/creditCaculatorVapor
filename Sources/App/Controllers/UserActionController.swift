//
//  UserController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor
import FluentMySQL
import Fluent
import Crypto

struct UserActionController {
    
     let authController = AuthController()
    
    
    func registerUserHandler(_ req: Request, paramers: RegisterUserContainer) throws -> Future<Response> {
        let logger = try req.make(Logger.self)
        
        logger.debug("register")
        
        logger.debug("register container --> \(paramers)" )

        let first = User.query(on: req).filter(\.username == paramers.username).first()
        
        return first.flatMap({ (exiUser) in
            
            
            
            let user = try User(username: paramers.username, password: paramers.password)
            
            return  user.save(on: req).flatMap({ (user) in
                
                
                logger.debug("create new user: \(user.username)")
                
                return try self.authController.authContainer(for: user, on: req).flatMap({ (container) in
                    
                    var access = AccessContainer(accessToken: container.accessToken)
                    
                    if !req.environment.isRelease {
                        access.userID = user.userID
                    }
                    
                    
                    let vo = ResponseJSON<AccessContainer>(status: ResponseCode.success, message: "注册成功", data: access)
                    return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                })
            })
            
        })
        
    }

    
    //TODO: 登录
    func loginUserHandler(_ req: Request,login: LoginContainer) throws -> Future<Response> {
        
        
        
        let first = User.query(on: req).filter(\.username == login.username).first()
        return first.flatMap({ (existingUser) in
            guard let existingUser = existingUser else {
                let vo = ResponseJSON<Empty>(status: .userNotExist)
                return try VaporResponseUtil.makeResponse(req: req, vo: vo)
            }
            
            let digest = try req.make(BCryptDigest.self)
            guard try digest.verify(login.password, created: existingUser.password) else {
                let vo = ResponseJSON<Empty>(status: .passwordError)
                return try VaporResponseUtil.makeResponse(req: req, vo: vo)
            }
            
            return try self.authController.authContainer(for: existingUser, on: req).flatMap({ (container) in
                
                var access = AccessContainer(accessToken: container.accessToken)
                if !req.environment.isRelease {
                    access.userID = existingUser.userID
                }
                let vo = ResponseJSON<AccessContainer>(status: .success,
                                                     message: "登录成功",
                                                     data: access)
                return try VaporResponseUtil.makeResponse(req: req, vo: vo)
            })
        })
    }
    
    //TODO 退出登录
    func exitUserHandler(_ req: Request) throws -> Future<Response> {
        
        let user = try req.authed(User.self)
        if let userid = user?.userID {
            return AccessToken.query(on: req).filter(\.userID == userid).first().flatMap({ (existToken) in
                guard let existToken = existToken else {
                    let vo = ResponseJSON<Empty>(status: .tokenExpire)
                    return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                }
                
                return try self.authController.remokeTokens(userID: existToken.userID, on: req).flatMap({ _ in
                    let vo = ResponseJSON<Empty>(status: .success,
                                               message: "退出成功")
                    return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                })
            })
        }
        
        return try ResponseJSON<Empty>(status: ResponseCode.error).encode(for: req)
    }
    
    // 用户信息
    func userinfo(_ req: Request) throws -> Future<Response> {
        
        let userid = try req.authed(User.self)!.userID
        
        return try ResponseJSON<Empty>(status: ResponseCode.error).encode(for: req)
    }
    
    //TODO: 修改密码
    func changePasswordHandler(_ req: Request,inputContent: ChangePasswordContainer) throws -> Future<Response> {
        
        //        let user = try req.authed(UserInfo.self)
        let user = try req.authed(User.self)
        
        if let userId = user?.userID {
            
            let phone = inputContent.username
       
                    return User.query(on: req).filter(\.username == inputContent.username).filter(\.userID == userId).first().flatMap({ (existUser) in
                        
                        
                        guard let existUser = existUser else {
                            let vo = ResponseJSON<Empty>(status: .userNotExist)
                            return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                        }
                        //                    let digest = try req.make(BCryptDigest.self)
                        //                    guard try digest.verify(inputContent.password, created: existUser.password) else {
                        //                        let vo = ResponseVO<Empty>(status: .passwordError)
                        //                        return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                        //                    }
                        
                        let digest = try req.make(BCryptDigest.self)
                        guard try digest.verify(inputContent.password, created: existUser.password) else {
                            let vo = ResponseJSON<Empty>(status: .passwordError)
                            return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                        }
                        
                        if inputContent.newPassword.isPassword().0 == false {
                            let vo = ResponseJSON<Empty>(status: .error,
                                                       message: inputContent.newPassword.isPassword().1)
                            return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                        }
                        
                        var user = existUser
                        
                        user.password = try digest.hash(inputContent.newPassword)
                        
                        return user.save(on: req).flatMap { newUser in
                            
                            let logger = try req.make(Logger.self)
                            logger.info("Password Changed Success: \(newUser.username)")
                            let vo = ResponseJSON<Empty>(status: .success,
                                                       message: "修改成功，请重新登录！")
                            return try VaporResponseUtil.makeResponse(req: req, vo: vo)
                        }
                    })
                }
        
        return try ResponseJSON<Empty>(status: ResponseCode.error).encode(for: req)
    }
}
