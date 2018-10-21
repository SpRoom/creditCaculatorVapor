//
//  LoanContainer.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation

struct LoanContainer : BaseContainer {
    
    /// 名称
    var name: String
    /// 总额
    var lines: Int
    /// 还款日
    var reimsementDate: Int
    /// 借款日
    var borrowDate: TimeInterval
    /// 分期计划，分为单位，用都好隔开每期
    var instaments: String
}
