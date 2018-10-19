//
//  UserActionRouter.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor

extension UserActionController : RouteCollection {
    
    func boot(router: Router) throws {
        
        let user = router.grouped("api","v1")
        // 注册
        user.post(RegisterUserContainer.self, at: "register", use: registerUserHandler)
        // 登录
        user.post(LoginContainer.self, at: "login", use: loginUserHandler)
        
       let auth = user.grouped(AuthMiddleware())
//        修改密码
        auth.post(ChangePasswordContainer.self, at: "changePassword", use: changePasswordHandler)
//        退出登录
        auth.post("exit", use: exitUserHandler)
    }
}
