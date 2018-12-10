//
//  AccountModel.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/20.
//

import Foundation
import Vapor
import FluentMySQL
import Fluent
import Crypto

struct AccountModel {
    
    func accountTypeName(req: Request, id: Int) throws -> Future<AccountType> {
        
        return AccountType.query(on: req).filter(\.id == id).first().flatMap({ (type)  in
            
            guard let type = type else {
                throw ResponseError(code: ResponseCode.error, message: "账户类型错误")
            }
            
            return req.future(type)
            
        })
    }
    
    // 删除账户
    func delAccount(req: Request, id: Int) throws -> Future<Account> {
        
        let user = try req.authed(User.self)!
        
        
        return accountInfo(req: req, id: id).flatMap { (account)  in
            guard var acc = account else {
                throw ResponseError(code: .error, message: "对应账户不存在")
            }
            
            guard acc.userID == user.userID else {
                throw ResponseError(code: ResponseCode.error, message: "请确认当前账户是否是你的")
            }
            
            acc.isDel = true
            
            return req.withPooledConnection(to: sqltype, closure: { (conn)  in
                return conn.transaction(on: sqltype, { (conn)  in
                    return acc.save(on: conn).flatMap({ account in
                        return req.future(account)
                    })
                })
            })
        }
    }
    
    
    /// 可用总余额
    ///
    /// - Parameter
    /// - Returns:
    /// - Throws:
    func avaBalance(req: Request) throws -> Future<Int> {
        
        return try userAccounts(req: req).flatMap { (accounts)  in
            
           let balance = accounts.compactMap({ (account) in
               let lines = account.lines
                let temp = account.temporaryLines
                let use = account.userLines
            
                return (lines + temp - use)
                
//                balance = balance +
//                return account
           }).reduce(0, +)
            
            return req.future(balance)
        }
        
    }
    
    /// 获取用户所有的账户
    ///
    /// - Parameter
    /// - Returns: 所有账户信息
    /// - Throws:
    func userAccounts(req: Request) throws -> Future<[Account]> {
        let user = try req.authed(User.self)!
        
       return Account.query(on: req).filter(\.userID == user.userID).filter(\.isDel == false).all().flatMap { (acs) in
            return req.future(acs)
        }
        
    }
    
    /// 编辑账户
    ///
    /// - Parameters:
    ///   - id: 账户id
    ///   - name: 账户名
    ///   - cardNo: 卡号
    ///   - accountTypeId: 类型id
    ///   - lines: 额度
    ///   - temporaryLines: 临时额度
    ///   - billDate: 账单日
    ///   - reimsementDate: 还款日
    /// - Returns: 编辑后的数据
    func editAccount(req: Request,id: Int, name: String, cardNo: String, accountTypeId: Int, lines: Int, temporaryLines: Int,useLines: Int, billDate: Int, reimsementDate: Int) throws -> Future<Account> {
        let user = try req.authed(User.self)!
        return accountInfo(req: req, id: id).flatMap { (account)  in
            guard var acc = account else {
                throw ResponseError(code: .error, message: "对应账户不存在")
            }
            
            guard acc.userID == user.userID else {
                throw ResponseError(code: ResponseCode.error, message: "请确认当前账户是否是你的")
            }
            
            acc.name = name
            acc.cardNo = cardNo
            acc.accountTypeId = accountTypeId
            acc.lines = lines
            acc.temporaryLines = temporaryLines
            acc.billDate = billDate
            acc.reimsementDate = reimsementDate
            acc.userLines = useLines
            
            return req.withPooledConnection(to: sqltype, closure: { (conn)  in
                return conn.transaction(on: sqltype, { (conn)  in
                    return acc.save(on: conn).flatMap({ account in
                        return req.future(account)
                    })
                })
            })
        }
    }
    
    /// 获取对应账户信息
    ///
    /// - Parameters:
    ///   - id: 账户id
    /// - Returns: 对应账户数据
    func  accountInfo(req: Request, id: Int) -> Future<Account?> {
        
       return Account.query(on: req).filter(\.id == id).first().flatMap { (account)  in
            return req.future(account)
        }
        
    }
    
    
    /// 添加账户
    ///
    /// - Parameters:
    ///   - name: 银行名
    ///   - cardNo: 卡号
    ///   - accountTypeId: 分类ID
    ///   - lines: 额度
    ///   - temporaryLines: 临时额度
    ///   - billDate: 账单日
    ///   - reimsementDate: 还款日
    /// - Returns: 插入的账户数据
    /// - Throws: <#throws value description#>
    func addAccount(req: Request, name: String, cardNo: String, accountTypeId: Int, lines: Int, temporaryLines: Int, billDate: Int, reimsementDate: Int) throws -> Future<Account> {
        
        let user = try req.authed(User.self)!
        
        let account = Account.init(id: nil, userID: user.userID, accountTypeId: accountTypeId, name: name, cardNo: cardNo, lines: lines, temporaryLines: temporaryLines, billDate: billDate, reimsementDate: reimsementDate, userLines: 0,isDel: false, createTime: Date().timeIntervalSince1970)
        
        return req.withPooledConnection(to: sqltype, closure: { (conn)  in
            return conn.transaction(on: sqltype, { (conn)  in
                return account.save(on: conn).flatMap({ account in
                    return req.future(account)
                })
            })
        })
    }
    
    /// 添加账户类型
    ///
    /// - Parameters:
    ///   - name: 类型名
    /// - Returns: 插入的数据
    /// - Throws: <#throws value description#>
    func addAccountType(req: Request, name: String) throws -> Future<AccountType> {
        
        _ = try req.authed(User.self)!
        
        return req.withPooledConnection(to: sqltype, closure: { (conn)  in
            return conn.transaction(on: sqltype, { (conn)  in
                return AccountType(id: nil,name: name, createTime: Date().timeIntervalSince1970).save(on: conn).flatMap({ type in
                    return req.future(type)
                })
            })
        })
        
    }
    
    /// 获取账户类型
    ///
    /// - Returns: 界面显示的数据列表
    /// - Throws: <#throws value description#>
    func getAccountType(req: Request) throws -> Future<[AccountTypeVO]> {
        
        return req.withPooledConnection(to: sqltype, closure: { (conn)  in
                return AccountType.query(on: conn).all().flatMap({ (types)  in
                    return req.future(types)
                }).map({ (types)  in
                    return types.compactMap({ (type) in
                        let v = AccountTypeVO(id: type.id!, name: type.name)
                        return v
                    })
                })
                    

        })
    }
    
}
