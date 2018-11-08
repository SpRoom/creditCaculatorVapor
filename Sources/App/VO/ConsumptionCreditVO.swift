//
//  ConsumptionCreditVO.swift
//  App
//
//  Created by spectator Mr.Z on 2018/11/8.
//

import Foundation

struct ConsumptionCreditVO: BaseValueObject  {
    /// 账户id
    var id: Int
    /// 账户分类id
    var accountTypeId: Int
    /// 账户分类
    var accountType: String
    /// 账户名
    var name: String
    /// 卡号
    var cardNo: String
    /// 额度
    var lines: Int
    /// 可用额度
    var balance: Int
    /// 账单日
    var billDate: Int
    /// 还款日
    var reimsementDate: Int
    
    /// 状态信息
    var statusMsg : String
}
