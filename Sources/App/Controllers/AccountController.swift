//
//  AccountController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/20.
//

import Foundation
import Vapor

struct AccountController {
    
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
            let json = ResponseJSON<Empty>(status: .success)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
    }
    
}
