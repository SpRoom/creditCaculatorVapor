//
//  BillVO.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation

struct BillVO : BaseValueObject {
    /// 账单id
    var id: Int
    /// 账户id
//    var accountId: Int
    /// 账户名
    var accountName: String
    /// 卡号
    var accountNo: String
    /// 账单类型 1.信用卡 2.贷款分期 3.信用卡分期
    var accountType: Int
    /// 状态 0.未还 1.已还
    var status: Int
    /// 金额;单位 分
    var money: Int
    /// 还款日
    var reimnursementDate: TimeInterval
}
