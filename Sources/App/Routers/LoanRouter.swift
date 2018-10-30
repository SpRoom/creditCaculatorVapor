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
        
        
        
        let apiV1 = router.grouped("api","v1").grouped(AuthMiddleware())
        
        let loanV1 = apiV1.grouped("loan")
        
        /**
         *  @api post /api/v1/loan/addLoan 添加贷款
         *  @apiGroup Loan
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *   @apiParam name String 名称
         *  @apiParam lines int 总额 单位为分
         *  @apiParam reimsementDate int 还款日
         *   @apiParam borrowDate int/TimeInterval 借款日
         *    @apiParam instaments String 分期计划，分为单位，用都好隔开每期
         *
         *  @apiSuccess 1000 OK
         */
        loanV1.post(LoanContainer.self, at: "addLoan", use: addLoan)
        loanV1.post("loans", use: loans)
    }
}
