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
    
    func repay(req: Request, billId: Int, money: Int) throws -> Future<PaymentBill> {
        
        let userid = try req.authed(User.self)!.userID
        
        return PaymentBill.query(on: req).filter(\.userID == userid).filter(\.id == billId).first().flatMap { (bill)  in
            guard var bill = bill else {
                throw ResponseError(code: ResponseCode.error, message: "账单不存在")
            }
            
            guard money > 0 else {
                throw ResponseError(code: ResponseCode.error, message: "金额不能为小于1分")
            }
            
           var releasemoney = bill.money - money
            
            if releasemoney <= 0 {
                releasemoney = 0
                bill.status = 1
            }
            bill.money = releasemoney
            
           return Account.query(on: req).filter(\.id == bill.accountId).filter(\.userID == userid).first().flatMap({ (account)  in
            guard var account = account else {
                throw ResponseError(code: ResponseCode.error, message: "账单所属账户错误")
            }
            account.userLines = account.userLines - money
            
           let log = ConsumLog.init(id: nil, userID: userid, accountId: bill.accountId, accountTypeId: account.accountTypeId, money: money, consumType: 2, time: Date().timeIntervalSince1970, remark: "", isDel: false, createTime: Date().timeIntervalSince1970)
            
            return req.withPooledConnection(to: sqltype, closure: { (conn)  in
                return conn.transaction(on: sqltype, { (conn)  in
                    return account.save(on: conn).flatMap({ (acc) in
                        return bill.save(on: conn).flatMap({ (bill) in
                            return log.save(on: conn).flatMap({ log in
                                 return req.future(bill)
                            })
                           
                        })
                    })
                })
            })
            
            })
        }
    }

    /// POS机列表
    func poslist(req: Request) throws -> Future<[POSDevice]> {
        let userid = try req.authed(User.self)!.userID
        
        return POSDevice.query(on: req).filter(\.userID == userid).all().flatMap { (poses)  in
            return req.future(poses)
        }
    }
    
    // 添加POS机
    func addPos(req: Request, name: String) throws -> Future<POSDevice> {
        
        let userid = try req.authed(User.self)!.userID
        
        let dev = POSDevice.init(id: nil, userID: userid, name: name, createTime: Date().timeIntervalSince1970)
        
        return req.withPooledConnection(to: sqltype, closure: { (conn) in
            return conn.transaction(on: sqltype, { (conn)  in
                return dev.save(on: conn).flatMap({ (acc)  in
                    return req.future(acc)
                })
                
            })
        })
    }
    
    /// 消费
    ///
    /// - Parameters:
    ///   - accountId: 账户id
    ///   - consumptionType: 消费类型 1.消费  2.信用卡分期
    ///   - money: 金额 单位 ：分
    ///   - consumptionDate: 消费日
    ///   - device: 设备ID 设备为 0 的时候 不属于自己添加的设备列表
    ///   - remark: 备注
    /// - Returns:
    /// - Throws:
    func addConsumptionBill(req: Request, accountId: Int, consumptionType: Int, money: Int, consumptionDate: TimeInterval, device: Int, remark: String) throws -> Future<CreditConsumptionBill> {
        let userid = try req.authed(User.self)!.userID
        
        return Account.query(on: req).filter(\.userID == userid).filter(\.id == accountId).first().flatMap({ (acc)  in
            guard var acc = acc else {
                throw ResponseError(code: ResponseCode.error, message: "请选择正确的账户")
            }
            acc.userLines = acc.userLines + money
            return POSDevice.query(on: req).filter(\.userID == userid).first().flatMap({ (pos)  in
                
                guard (pos != nil) || device == 0 else {
                    throw ResponseError(code: ResponseCode.error, message: "当前设备不属于您")
                }
                
                let bill = CreditConsumptionBill.init(id: nil, accountId: accountId, consumptionType: consumptionType, money: money, consumptionDate: consumptionDate, device: device, remark: remark, isDel: false, createTime: Date().timeIntervalSince1970)
                
                let log = ConsumLog.init(id: nil, userID: userid, accountId: accountId, accountTypeId: acc.accountTypeId, money: money, consumType: 1, time: Date().timeIntervalSince1970, remark: remark, isDel: false, createTime: Date().timeIntervalSince1970)
                
                return req.withPooledConnection(to: sqltype, closure: { (conn) in
                    return conn.transaction(on: sqltype, { (conn)  in
                        return acc.save(on: conn).flatMap({ (acc)  in
                            return log.save(on: conn).flatMap({ (log) in
                                return bill.save(on: conn).flatMap({ (bill) in
                                    return req.future(bill)
                                })
                            })
                        })
                        
                    })
                })
                
            })
        })
        
        
        
        
    }
    
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
            guard var acc = acc else {
                throw ResponseError(code: ResponseCode.error, message: "请选择正确的账户")
            }
        
        acc.userLines = acc.userLines + money
        
            
        let bill = PaymentBill.init(id: nil, accountId: acc.id!, accountType: accountType, status: 0, money: money, reimnursementDate: reimnursementDate, isDel: false, userID: userid, createTime: Date().timeIntervalSince1970)
            
            return req.withPooledConnection(to: sqltype, closure: { (conn) in
                return conn.transaction(on: sqltype, { (conn)  in
                    return acc.save(on: conn).flatMap({ (acc)  in
                        return bill.save(on: conn).flatMap({ (bill) in
                            return req.future(bill)
                        })
                    })
                    
                })
            })
        }
        
       
        
    }
    
    /// 待还款账单
    func needRepaymentBills(req: Request) throws -> Future<[BillVO]> {
        
        let userid = try req.authed(User.self)!.userID
        
        return PaymentBill.query(on: req).filter(\PaymentBill.userID == userid).filter(\.status == 0).filter(\.isDel == false).sort(\PaymentBill.reimnursementDate, .ascending).all().flatMap { (bills)  in
            
            return bills.compactMap({ (bill) -> Future<BillVO?> in
                
                if bill.accountType == 2 {
                    // loan
                    return Loan.query(on: req).filter(\.id == bill.accountId).filter(\.isDel == false).first().flatMap({ (loan) -> Future<BillVO?> in
                        var billVO : BillVO?
                        if let loan = loan {
                            billVO =  BillVO(id: bill.id!, accountName: loan.name, accountNo: "", accountType: bill.accountType, status: bill.status, money: bill.money, reimnursementDate: bill.reimnursementDate)
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
                            billVO =  BillVO(id: bill.id!, accountName: loan.name, accountNo: "", accountType: bill.accountType, status: bill.status, money: bill.money, reimnursementDate: bill.reimnursementDate)
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
