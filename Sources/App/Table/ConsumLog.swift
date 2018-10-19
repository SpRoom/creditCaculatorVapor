//
//  consumLog.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 消费记录
struct ConsumLog : BaseSQLModel {
    var id: Int?
    /// 用户唯一标识
    var userID: String
    /// 账户id
    var accountId: String
    /// 账户类型
    var accountTypeId: Int
    /// 金额
    var money: String
    /// 消费类型
    var consumType: Int
    /// 消费时间
    var time: TimeInterval
    /// 备注
    var remark: String
    
}
