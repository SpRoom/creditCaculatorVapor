//
//  User.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor
import Authentication
import Crypto
/// 用户
struct User: BaseSQLModel,AuthContent {
    
    var id: Int?
    
    /// 用户唯一标识
    var userID: String
    /// 登陆账号
    var username: String
    /// 登陆密码
    var password: String
    /// 是否删除
    var isDel: Bool
    /// 添加时间
    var createTime: TimeInterval
    
    init(userID: String, username: String, password: String) {
        
        self.userID = userID
        self.username = username
        self.password = password
        self.isDel = false
        self.createTime = Date().timeIntervalSince1970
    }
    
    init(username: String, password: String) throws {
        self.isDel = false
        self.username = username
        
        let digest = BCryptDigest()
        self.password = try digest.hash(password)
        
        self.userID = UUID().uuidString
        self.createTime = Date().timeIntervalSince1970
    }
    
}

extension User: BasicAuthenticatable {
    
    static var usernameKey: WritableKeyPath<User, String> = \.username
    static var passwordKey: WritableKeyPath<User, String> = \.password
}
