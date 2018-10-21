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
                return AccountType(name: name).save(on: conn).flatMap({ type in
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
