//
//  ResponseJSON.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor

struct Empty: Content {}

struct ResponseJSON<T: Content> : Content {
    
    var code: ResponseCode
    var msg : String
    var data : T?
    
    init(status: ResponseCode ) {
        self.code = status
        self.msg = status.desc
        self.data = nil
    }
    
    init(data: T) {
        self.code = .success
        self.msg = code.desc
        self.data = data
    }
    
    init(status:ResponseCode = .success,
         message: String = ResponseCode.success.desc) {
        self.code = status
        self.msg = message
        self.data = nil
    }
    
    init(status:ResponseCode = .success,
         message: String = ResponseCode.success.desc,
         data: T?) {
        self.code = status
        self.msg = message
        self.data = data
    }
    
    
}
