//
//  AccountRouter.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/20.
//

import Foundation
import Vapor


extension AccountController : RouteCollection {
    
    func boot(router: Router) throws {
        
        /**
         *  @apidoc account
         *  @apiVersion 1.0
         *  @apiBaseURL http://localhost:8080
         *
         */
        
        
        
        let apiV1 = router.grouped("api","v1").grouped(AuthMiddleware())
        
        let accountV1 = apiV1.grouped("account")
        
        
        accountV1.post(NameContainer.self, at: "addAccountType", use: addAccountType)
        accountV1.post("accountTypes", use: accountTypes)
        accountV1.post(AccountContainer.self, at: "addAccount", use: addAccount)
        accountV1.post(EditAccountContainer.self, at: "editAccount", use: editAccount)
        /**
         *  @api post /api/v1/account/account 获取账户信息
         *  @apiGroup account
         * 
         *  @apiParam id int 对应账户ID
         *
         *  @apiSuccess 1000 OK
         *  @apiExample json
         *  { "id" : 1 }
         */
        accountV1.post(IDContainer.self, at: "account", use: account)
    }
}
