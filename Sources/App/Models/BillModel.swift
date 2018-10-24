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
