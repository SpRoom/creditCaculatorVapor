//
//  BillModel.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor
import FluentMySQL
import Fluent
import SwiftDate


struct BillModel {
    
    /// 添加信用卡账单
    ///
    /// - Parameters:
    ///   - req:
    ///   - accountId: 账户ID
    ///   - accountTypeId: 账单类型 1.信用卡 2.贷款分期 3.信用卡分期
    ///   - money: 金额;单位 分
    ///   - reimnursementDate: 还款日
    /// - Returns:
    /// - Throws:
    func addCreditMonthBill(req: Request, accountId: Int, accountType: Int, money: Int, reimnursementDate: TimeInterval) throws -> Future<PaymentBill> {
        
        let userid = try req.authed(User.self)!.userID
        
       return Account.query(on: req).filter(\.userID == userid).filter(\.id == accountId).first().flatMap { (acc) in
            guard let acc = acc else {
                throw ResponseError(code: ResponseCode.error, message: "请选择正确的账户")
            }
            
            let bill = PaymentBill.init(id: nil, accountId: acc.id!, accountType: accountType, status: 0, money: money, reimnursementDate: reimnursementDate, isDel: false, userID: userid)
            
            return req.withPooledConnection(to: sqltype, closure: { (conn) in
                return conn.transaction(on: sqltype, { (conn)  in
                    return bill.save(on: conn).flatMap({ (bill) in
                        return req.future(bill)
                    })
                })
            })
        }
        
       
        
    }
    
    /// 查询自己所有的账单
    ///
    /// - Parameter
    /// - Returns: 账单列表
    /// - Throws: 
    func bills(req: Request) throws -> Future<[BillVO]> {
        
        let userid = try req.authed(User.self)!.userID
        
        return PaymentBill.query(on: req).filter(\PaymentBill.userID == userid).sort(\PaymentBill.reimnursementDate, .ascending).all().flatMap { (bills)  in
            
            return bills.compactMap({ (bill) -> Future<BillVO?> in
                
                if bill.accountType == 2 {
                    // loan
                    return Loan.query(on: req).filter(\.id == bill.accountId).filter(\.isDel == false).first().flatMap({ (loan) -> Future<BillVO?> in
                        var billVO : BillVO?
                        if let loan = loan {
                            billVO =  BillVO(id: bill.id!, accountName: loan.name, accountNo: "loan", accountType: bill.accountType, status: bill.status, money: bill.money, reimnursementDate: bill.reimnursementDate)
                        }
                        return req.future(billVO)
                    })
                    
                } else {
                    // card
                    return Account.query(on: req).filter(\.id == bill.accountId).filter(\.isDel == false).first().flatMap({ (account)  in
                        var billVO : BillVO?
                        if let account = account {
                            billVO =  BillVO(id: bill.id!, accountName: account.name, accountNo: account.cardNo, accountType: bill.accountType, status: bill.status, money: bill.money, reimnursementDate: bill.reimnursementDate)
                        }
                        return req.future(billVO)
                    })
                }
            }).flatten(on: req).flatMap({ (bills)  in
                
                let arr = bills.filter({
                    $0 != nil
                }).map({
                    $0!
                })
                
                return req.future(arr)
                
            })
            
            
        }
        
    }
    
}
