//
//  LoanModel.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/20.
//

import Foundation
import Vapor
import FluentMySQL
import Fluent
import SwiftDate

struct LoanModel {
    
    /// 添加贷款
    ///
    /// - Parameters:
    ///   - lines: 借款金额
    ///   - reimsementDate: 还款日
    ///   - borrowDate: 借款日
    /// - Returns: 插入的数据
    func addLoan(req: Request,name: String, lines: Int, reimsementDate: Int, borrowDate: TimeInterval) throws -> Future<Loan> {
        
        let user = try req.authed(User.self)!
        
        return req.withPooledConnection(to: sqltype, closure: { (conn)  in
            return conn.transaction(on: sqltype, { (conn) in
                return Loan(id: nil, userID: user.userID,name:name, lines: lines, reimnursementDate: reimsementDate, borrowDate: borrowDate,isDel: false).save(on: conn).flatMap({ (loan)  in
                    return req.future(loan)
                })
            })
        })
    }
    
    /// 添加贷款分期账单
    ///
    /// - Parameters:
    ///
    ///   - reimsementDate: 还款日
    ///   - moneys: 金额 字符串 每期之间使用`,`隔开
    /// - Returns: 插入的数据
    func addBills(req: Request,loanId: Int, borrowDate:TimeInterval, reimsementDate: Int,moneys: String) throws -> Future<[PaymentBill]> {
        
        let user = try req.authed(User.self)!
        
        let moneyArr = moneys.components(separatedBy: ",").map {
            Int($0) ?? 0
        }
        
        let dateRegion = DateInRegion(seconds: borrowDate)
        
        var reimsementDateRegion = DateInRegion(components: {
            $0.year = dateRegion.year
            $0.month = dateRegion.month + 1
            $0.day = reimsementDate
            $0.hour = 0
            $0.minute = 0
            })!
        // 如果region 计算失败  换用date
        var reimsementDate = reimsementDateRegion.date
        
        let bills = moneyArr.compactMap { (money)  -> PaymentBill in
            
            let loan = PaymentBill.init(id: nil, accountId: loanId, accountType: 2, status: 0, money: money*100, reimnursementDate: reimsementDateRegion.date.timeIntervalSince1970,isDel: false, userID: user.userID)
               reimsementDateRegion = reimsementDateRegion + 1.months
            return loan
        }
        
        return req.withPooledConnection(to: sqltype, closure: { (con)  in
            return con.transaction(on: sqltype, { (conn)  in
                return bills.compactMap({ (bill) in
                    return bill.save(on: conn).flatMap({ bill in
                        return req.future(bill)
                    })
                }).flatten(on: req)
            })
        })
        
       
    }
    
    
}
