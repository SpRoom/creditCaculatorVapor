//
//  ConsumType.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 消费主分类
struct ConsumType : BaseSQLModel {
    
    var id: Int?
    /// 名称
    var name: String
    /// 添加时间
    var createTime: TimeInterval
}
