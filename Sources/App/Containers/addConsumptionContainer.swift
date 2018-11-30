//
//  addConsumptionContainer.swift
//  App
//
//  Created by spectator Mr.Z on 2018/11/29.
//

import Foundation

struct addConsumptionContainer : BaseContainer {
    
    /// 账户ID
    var accountId: Int
    /// 消费类型 1.消费  2.信用卡分期
    var consumptionType: Int
    /// 金额 单位 ：分
    var money: Int
    /// 消费日
    var consumptionDate: TimeInterval
    /// 设备ID 设备为 0 的时候 不属于自己添加的设备列表
    var device: Int
    /// 备注
    var remark: String
}
