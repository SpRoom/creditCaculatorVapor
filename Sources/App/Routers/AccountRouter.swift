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
        
        let apiV1 = router.grouped("api","v1")
        
        let accountV1 = apiV1.grouped("account")
        
        accountV1.post(NameContainer.self, at: "addAccountType", use: addAccountType)
    }
}
