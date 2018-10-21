//
//  AccountVO.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation

struct AccountVO: BaseValueObject  {
    /// 账户id
    var id: Int
    /// 账户分类id
    var accountTypeId: Int
    /// 账户名
    var name: String
    /// 卡号
    var cardNo: String
    /// 额度
    var lines: Int
    /// 临时额度
    var temporary: Int
    /// 账单日
    var billDate: Int
    /// 还款日
    var reimsementDate: Int
}
