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
         *  @api post /api/v1/bill/addCreditMonthBill 添加信用卡月账单
         *  @apiGroup Bill
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam accountId int 对应账户ID
         *  @apiParam accountType int 1.信用卡 2.贷款分期 3.信用卡分期
         *  @apiParam money int 金额;单位 分
         *  @apiParam reimsementDate int 还款日
         *
         *  @apiSuccess 1000 OK
         *
         */
        billV1.post(AddBillContainer.self, at: "addCreditMonthBill", use: addCreditMonthBill)
        /**
         *  @api post /api/v1/bill/bills 查询自己所有的账单
         *  @apiGroup Bill
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *
         *  @apiSuccess 1000 OK
         *
         */
        billV1.post("bills", use: bills)
    }
}
