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
        
        /**
         *  @api post /api/v1/register 注册
         *  @apiGroup userAction
         *  @apiRequest
         *  @apiParam username String 用户名
         *  @apiParam password String 密码
         *  @apiSuccess 1000 OK
         *
         */
        user.post(RegisterUserContainer.self, at: "register", use: registerUserHandler)
        /**
         *  @api post /api/v1/login 登陆
         *  @apiGroup userAction
         *  @apiRequest
         *  @apiParam username String 用户名
         *  @apiParam password String 密码
         *  @apiSuccess 1000 OK
         *
         */
        user.post(LoginContainer.self, at: "login", use: loginUserHandler)
        
       let auth = user.grouped(AuthMiddleware())

        /**
         *  @api post /api/v1/changePassword 修改密码
         *  @apiGroup userAction
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam username String 用户名
         *  @apiParam password String 旧密码
         *  @apiParam newPassword String 新密码
         *  @apiSuccess 1000 OK
         *
         */
        auth.post(ChangePasswordContainer.self, at: "changePassword", use: changePasswordHandler)

        /**
         *  @api post /api/v1/exit 退出登录
         *  @apiGroup userAction
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiSuccess 1000 OK
         *
         */
        auth.post("exit", use: exitUserHandler)
    }
}
