//
//  BillRouter.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor
extension BillController : RouteCollection {
    
    func boot(router: Router) throws {
        
        
        
        let apiV1 = router.grouped("api","v1").grouped(AuthMiddleware())
        
        let billV1 = apiV1.grouped("bill")
        
        /**
         *  @api post /api/v1/bill/bills 查询自己所有的账单
         *  @apiGroup Bill
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *
         *  @apiSuccess 1000 OK
         */
        billV1.post("bills", use: bills)
    }
}
