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
        
        let apiV1 = router.grouped("api","v1").grouped(AuthMiddleware())
        
        let accountV1 = apiV1.grouped("account")
        
        accountV1.post(NameContainer.self, at: "addAccountType", use: addAccountType)
        accountV1.post("accountTypes", use: accountTypes)
        accountV1.post(AccountContainer.self, at: "addAccount", use: addAccount)
        accountV1.post(EditAccountContainer.self, at: "editAccount", use: editAccount)
        accountV1.post(IDContainer.self, at: "account", use: account)
    }
}
