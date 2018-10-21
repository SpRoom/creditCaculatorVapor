//
//  LoanRouter.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor

extension LoanController : RouteCollection {
    
    func boot(router: Router) throws {
        
        let apiV1 = router.grouped("api","v1")
        
        let loanV1 = apiV1.grouped("loan")
        
        loanV1.post(LoanContainer.self, at: "addLoan", use: addLoan)
    }
}
