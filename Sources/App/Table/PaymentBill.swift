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
    /// 金额
    var money: Double
    /// 还款日
    var reimnursementDate: TimeInterval
    

}
