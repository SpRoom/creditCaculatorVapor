//
//  CreditConsumptionBill.swift
//  App
//
//  Created by spectator Mr.Z on 2018/11/26.
//

import Foundation

struct CreditConsumptionBill : BaseSQLModel {
    
    var id: Int?
    /// 账户id
    var accountId: Int
    /// 消费类型 1.消费 2.分期
    var consumptionType:Int
    /// 金额；单位:分
    var money : Int
    /// 消费日
    var consumptionDate: TimeInterval
    /// 设备id 默认为0 0为不在自己添加的设备中
    var device: Int
    /// 备注
    var remark: String
    /// 是否删除
    var isDel: Bool
}
