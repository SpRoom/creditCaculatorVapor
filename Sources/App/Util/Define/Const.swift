//
//  Const.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/17.
//

import Foundation

// password
public let PasswordMaxCount = 18
public let passwordMinCount = 6

//account
public let AccountMaxCount = 18
public let AccountMinCount = 6

//phone
public let PhoneCount = 11

//image
public let ImageMaxByteSize = 2048000

// list page
public let pageCount = 20


// upload
struct ImagePath {
    
    static let record = "record" //动态
    static let report = "report" // 举报
    static let userPic = "userPic" // 用户头像
    static let ticket = "ticket" // 票
}

struct DirPath {
    
    struct LogPath {
        static let info = "info"
    }
}


