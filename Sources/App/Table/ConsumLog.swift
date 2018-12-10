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
    var accountId: Int
    /// 账户类型
    var accountTypeId: Int
    /// 金额;单位 分
    var money: Int
    /// 消费类型 1.消费 2.还款
    var consumType: Int
    /// 消费时间
    var time: TimeInterval
    /// 备注
    var remark: String
    /// 是否删除
    var isDel: Bool
    /// 添加时间
    var createTime: TimeInterval
}
