//
//  PaymentBill.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 还款/分期账单
struct PaymentBill: BaseSQLModel {
    
    var id: Int?
    /// 账户id
    var accountId: Int
    /// 账单类型 1.信用卡 2.贷款分期 3.信用卡分期
    var accountType: Int
    /// 状态 0.未还 1.已还
    var status: Int
    /// 金额;单位 分
    var money: Int
    /// 还款日
    var reimnursementDate: TimeInterval
    /// 是否删除
    var isDel: Bool
    /// 用户唯一标识
    var userID: String

}
