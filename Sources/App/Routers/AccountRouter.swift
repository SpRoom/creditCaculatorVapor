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
         *  @apidoc credictCaculator
         *  @apiVersion 1.0
         *  @apiBaseURL http://localhost:8080
         *
         */
        
        
        
        let apiV1 = router.grouped("api","v1").grouped(AuthMiddleware())
        
        let accountV1 = apiV1.grouped("account")
        
        /*
         *  @api post /api/v1/account/consumAccountList 消费列表可用卡
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *
         *  @apiSuccess 1000 OK
         */
        accountV1.post("consumAccountList", use: consumAccountList)
        
        /*
         *  @api post /api/v1/account/balance 可用总额
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *
         *  @apiSuccess 1000 OK
         */
        accountV1.post("balance", use: balance)
        
        /**
         *  @api post /api/v1/account/delAccount 删除账户
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam id int 对应账户ID
         *
         *  @apiSuccess 1000 OK
         *
         */
        accountV1.post(IDContainer.self, at: "delAccount", use: delAccount)
        /*
         *  @api post /api/v1/account/accountTypes 获取账户列表
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *
         *  @apiSuccess 1000 OK
         */
        accountV1.post("accountList", use: accountList)
        
        
        /**
         *  @api post /api/v1/account/addAccountType 添加账户类型
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam name String 账户名
         *
         *  @apiSuccess 1000 OK
         *  @apiExample json
         *  { "id" : 1 }
         */
        accountV1.post(NameContainer.self, at: "addAccountType", use: addAccountType)
        /**
         *  @api post /api/v1/account/accountTypes 获取账户类型
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *
         *  @apiSuccess 1000 OK
         */
        accountV1.post("accountTypes", use: accountTypes)
        /**
         *  @api post /api/v1/account/addAccount 添加账户
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam accountTypeId int 账户分类id
         *   @apiParam name String 账户名
         *   @apiParam cardNo String 卡号
         *   @apiParam lines int 额度 单位为分
         *   @apiParam temporary int 临时额度 单位为分
         *   @apiParam billDate int 账单日
         *   @apiParam reimsementDate int 还款日
         *
         *  @apiSuccess 1000 OK
         */
        accountV1.post(AccountContainer.self, at: "addAccount", use: addAccount)
        /**
         *  @api post /api/v1/account/editAccount 编辑账户信息
         *  @apiGroup account
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam id int 对应账户ID
         *   @apiParam accountTypeId int 账户分类id
         *   @apiParam name String 账户名
         *   @apiParam cardNo String 卡号
         *   @apiParam lines int 额度 单位为分
         *   @apiParam temporary int 临时额度 单位为分
         *   @apiParam billDate int 账单日
         *   @apiParam reimsementDate int 还款日
         *
         *  @apiSuccess 1000 OK
         *
         */
        accountV1.post(EditAccountContainer.self, at: "editAccount", use: editAccount)
        /**
         *  @api post /api/v1/account/account 获取账户信息
         *  @apiGroup account
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam id int 对应账户ID
         *
         *  @apiSuccess 1000 OK
         *
         */
        accountV1.post(IDContainer.self, at: "account", use: account)
    }
}
