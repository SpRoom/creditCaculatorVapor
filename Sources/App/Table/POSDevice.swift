//
//  POSDevice.swift
//  App
//
//  Created by spectator Mr.Z on 2018/11/26.
//

import Foundation

struct POSDevice : BaseSQLModel {
    
    var id: Int?
    /// 用户唯一标识
    var userID: String
    /// 设备名
    var name: String
    /// 添加时间
    var createTime: TimeInterval
}
