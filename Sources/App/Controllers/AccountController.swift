//
//  AccountController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/20.
//

import Foundation
import Vapor

struct AccountController {
    
    /// 账户信息
    ///
    /// - Parameters:
    ///   - container: 参数模型
    /// - Returns: 账户信息
    /// - Throws: 
    func account(_ req: Request, container: IDContainer) throws -> Future<Response> {
        
        let accountModel = AccountModel()
        
        return accountModel.accountInfo(req: req, id: container.id).flatMap({ (account)  in
            guard let account = account else {
                throw ResponseError(code: .error, message: "账户不存在")
            }
            
            return try VaporResponseUtil.makeResponse(req: req, vo: ResponseJSON(data: AccountVO.init(id: account.id!, accountTypeId: account.accountTypeId, name: account.name, cardNo: account.cardNo, lines: account.lines, temporary: account.temporaryLines, billDate: account.billDate, reimsementDate: account.reimsementDate)))
            
        })
    }
    
    
    /// 编辑账户
    ///
    /// - Parameters:
    ///   - container: 参数模型
    /// - Returns: 编辑结果
    /// - Throws:
    func editAccount(_ req: Request, container: EditAccountContainer) throws -> Future<Response> {
        let id = container.id
        let accountTypeId = container.accountTypeId
        let name = container.name
        let cardno = container.cardNo
        let lines = container.lines
        let temporarylines = container.temporary
        let billdate = container.billDate
        let reimsement = container.reimsementDate
        
        let accountModel = AccountModel()
        
       return accountModel.editAccount(req: req, id: id, name: name, cardNo: cardno, accountTypeId: accountTypeId, lines: lines, temporaryLines: temporarylines, billDate: billdate, reimsementDate: reimsement).flatMap { (account) in
            let json = ResponseJSON<Empty>(status: .success)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
    }
    
    
    /// 添加账户
    ///
    /// - Parameters:
    ///   - container:
    ///     - name: 银行名
    ///     - cardNo: 卡号
    ///     - accountTypeId: 分类ID
    ///     - lines: 额度
    ///     - temporary: 临时额度
    ///     - billDate: 账单日
    ///     - reimsementDate: 还款日
    /// - Returns: 添加账户结果
    /// - Throws: <#throws value description#>
    func addAccount(_ req: Request, container: AccountContainer) throws -> Future<Response> {
        
        let accountTypeId = container.accountTypeId
        let name = container.name
        let cardno = container.cardNo
        let lines = container.lines
        let temporarylines = container.temporary
        let billdate = container.billDate
        let reimsement = container.reimsementDate
        
        let accountModel = AccountModel()
        
        return try accountModel.addAccount(req: req, name: name, cardNo: cardno, accountTypeId: accountTypeId, lines: lines, temporaryLines: temporarylines, billDate: billdate, reimsementDate: reimsement).flatMap { (account) in
            var json : ResponseJSON<Empty>!
            if account.id != nil {
                json = ResponseJSON<Empty>(status: .success)
            } else {
                json = ResponseJSON<Empty>(status: .error)
            }
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
        
    }
    
    /// 获取账户类型列表
    ///
    /// - Returns: 账户类型列表
    func accountTypes(_ req: Request) throws -> Future<Response> {
        
        let accountModel = AccountModel()
        
        return try accountModel.getAccountType(req: req).flatMap({ (types)  in
            let json = ResponseJSON(data: types)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        })
    }
    
    /// 添加账户类型
    ///
    /// - Parameters:
    ///   - req: 请求
    ///   - container: 参数
    ///     - name: 类型名称
    /// - Returns: 添加结果
    func addAccountType(_ req: Request, container: NameContainer) throws -> Future<Response> {
        
        let accountModel = AccountModel()
        
        return try accountModel.addAccountType(req: req, name: container.name).flatMap { (type)  in
            var json : ResponseJSON<Empty>!
            if type.id != nil {
             json = ResponseJSON<Empty>(status: .success)
            } else {
                json = ResponseJSON<Empty>(status: .error)
            }
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
    }
    
}
