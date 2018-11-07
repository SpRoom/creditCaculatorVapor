//
//  AddBillContainer.swift
//  App
//
//  Created by spectator Mr.Z on 2018/11/7.
//

import Foundation

struct AddBillContainer : BaseContainer {
    
    /// 账户id
    var accountId: Int
    /// 账单类型 1.信用卡 2.贷款分期 3.信用卡分期
    var accountType:Int
    /// 金额;单位 分
    var money: Int
    /// 还款日
    var reimsementDate: TimeInterval
}
