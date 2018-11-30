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
         *  @api post /api/v1/bill/poslist POS机列表
         *  @apiGroup Bill
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam name str 设备名
         *
         *  @apiSuccess 1000 OK
         *
         */
        billV1.post("poslist", use: posList)
        
        
        /**
         *  @api post /api/v1/bill/addPos 添加POS机
         *  @apiGroup Bill
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam name str 设备名
         *
         *  @apiSuccess 1000 OK
         *
         */
        billV1.post(NameContainer.self, at: "addPos", use: addPos)
        
        /**
         *  @api post /api/v1/bill/addConsumptionBill 添加消费账单
         *  @apiGroup Bill
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam accountId int 对应账户ID
         *  @apiParam consumptionType int 1.消费  2.信用卡分期
         *  @apiParam money int 金额;单位 分
         *  @apiParam consumptionDate int 消费日
         *  @apiParam device int 设备id  设备为 0 的时候 不属于自己添加的设备列表
         *  @apiParam remark str 备注
         *
         *  @apiSuccess 1000 OK
         *
         */
        billV1.post(addConsumptionContainer.self, at: "addConsumptionBill", use: addConsumptionBill)
        
        
        /**
         *  @api post /api/v1/bill/addCreditMonthBill 添加信用卡月账单
         *  @apiGroup Bill
         *
         *  @apiRequest
         *  @apiHeader X-AUTH-TOKEN token
         *  @apiParam accountId int 对应账户ID
         *  @apiParam accountType int 1.信用卡 2.贷款分期
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
