//
//  BillController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor

struct BillController {
    
    func repay(_ req: Request, container: RepayContainer) throws -> Future<Response> {
        
        let billModel = BillModel()
        
        return try billModel.repay(req: req, billId: container.billId, money: container.money).flatMap({ (bill)  in
            return try VaporResponseUtil.makeResponse(req: req, vo: ResponseJSON<Empty>(status: .success))
        })
    }
    
    // POS机列表
    func posList(_ req: Request) throws -> Future<Response> {
        
        let billModel = BillModel()
        
        return try billModel.poslist(req: req).flatMap({ (poses) in
            let json = ResponseJSON(data: poses)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        })
    }
    
    // 添加POS机
    func addPos(_ req: Request, container: NameContainer) throws -> Future<Response> {
        
        let billModel = BillModel()
        
        return try billModel.addPos(req: req, name: container.name).flatMap({ (dev)  in
            var json : ResponseJSON<Empty>!
            if let _ = dev.id {
                json = ResponseJSON<Empty>(status: .success)
            } else {
                json = ResponseJSON<Empty>(status: .error)
            }
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        })
    }
    
    /// 添加消费账单
    func addConsumptionBill(_ req: Request, container: addConsumptionContainer)  throws -> Future<Response>  {
        
        let billModel = BillModel()
        
       return try billModel.addConsumptionBill(req: req, accountId: container.accountId, consumptionType: container.consumptionType, money: container.money, consumptionDate: container.consumptionDate, device: container.device, remark: container.remark).flatMap { (bill)  in
            var json : ResponseJSON<Empty>!
            if let _ = bill.id {
                json = ResponseJSON<Empty>(status: .success)
            } else {
                json = ResponseJSON<Empty>(status: .error)
            }
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
    }
    
    /// 添加信用卡月账单
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
    
    /// 待还款账单
    func needRepaymentBills(_ req: Request) throws -> Future<Response> {
        
        let billModel = BillModel()
        
        return try billModel.needRepaymentBills(req: req).flatMap({ (bills)  in
            let json = ResponseJSON(data: bills)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        })
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
