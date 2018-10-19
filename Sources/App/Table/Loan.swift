//
//  Loan.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 贷款
struct Loan :  BaseSQLModel {
    
    var id: Int?
    /// 用户唯一标识
    var userID: String
    /// 额度
    var lines: String
    /// 还款日
    var reimnursementDate: Int
}
