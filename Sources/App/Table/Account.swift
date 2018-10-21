//
//  Account.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 账户
struct Account :  BaseSQLModel {
    
    var id: Int?
    /// 用户唯一标识
    var userID: String
    /// 账户类型
    var accountTypeId: Int
    /// 账户名（银行名）
    var name: String
    /// 卡号
    var cardNo: String
    /// 额度;单位 分
    var lines: Int
    /// 临时额度;单位 分
    var temporaryLines: Int
    /// 账单日
    var billDate: Int
    /// 还款日
    var reimsementDate: Int
    /// 已用额度;单位 分
    var userLines: Int
    /// 是否删除
    var isDel: Bool
}
