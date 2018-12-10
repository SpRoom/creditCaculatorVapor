//
//  AccountType.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 账户类型
struct AccountType: BaseSQLModel {
    var id: Int?
    /// 名称
    var name: String
    /// 添加时间
    var createTime: TimeInterval
    
}
