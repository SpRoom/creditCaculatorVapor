//
//  Account.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 账户
struct Account :  BaseSQLModel {
    
    var id: Int?
    /// 用户唯一标识
    var userID: String
    /// 账户类型
    var accountTypeId: Int
    /// 账户名（银行名）
    var name: String
    /// 额度
    var lines: Double
    /// 临时额度
    var teporaryLines: Double
    /// 账单日
    var billDate: Int
    /// 还款日
    var reimnursementDate: Int
    /// 已用额度
    var userLines: Double
    
}
