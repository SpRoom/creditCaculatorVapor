//
//  BillController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor

struct BillController {
    
    /// 添加信用卡账单
    ///
    /// - Parameters:
    ///   - req: <#req description#>
    ///   - container: <#container description#>
    func addCreditMonthBill(_ req: Request, container: AddBillContainer) throws -> Future<Response> {
        
        let billModel = BillModel()
        
       return try billModel.addCreditMonthBill(req: req, accountId: container.accountId, accountType: container.accountType, money: container.money, reimnursementDate: container.reimsementDate).flatMap { (bill)  in
           var json : ResponseJSON<Empty>!
            if let _ = bill.id {
                json = ResponseJSON<Empty>(status: .success)
            } else {
                json = ResponseJSON<Empty>(status: .error)
            }
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
        
    }
    
    
    /// 查询自己所有的账单
    ///
    /// - Parameter
    /// - Returns: 账单列表
    /// - Throws:
    func bills(_ req: Request) throws -> Future<Response> {
        
        let billModel = BillModel()
        
        return try billModel.bills(req: req).flatMap { (bills) in
            
            let json = ResponseJSON(data: bills)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
        
    }
}
