//
//  ConsumSubType.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation

/// 消费分类
struct ConsumSubType : BaseSQLModel {
    var id: Int?
    /// 主分类id
    var parentId: Int
    /// 名称
    var name: String
    /// 添加时间
    var createTime: TimeInterval
}
