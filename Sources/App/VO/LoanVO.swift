//
//  LoanVO.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/25.
//

import Foundation

struct LoanVO : BaseValueObject {
    
    /// loan id
    var id: Int
    /// loan 名称
    var name: String
    /// 状态 0.未还 1.已还
    var status: Int
    /// 本金
    var principay: Int
    /// 当前还款金额
    var reimsementValue: Int
    /// 每月还款日
    var reimsementDate: Int
}
