//
//  ResponseError.swift
//  App
//
//  Created by spectator Mr.Z on 2018/9/29.
//

import Foundation
import Vapor

public enum ResponseCode : Int, Content {
    case success = 1000
    case parameterError = 1001
    case error = 1002
    case powerOutOrder = 1005
    
    case passwordError = 1003
    case tokenExpire = 1008
    case tokenNotExist = 1004
    
    case userExist = 7001
    case userNotExist = 7002
    
    var desc : String {
        switch self {
        case .success:
            return "请求成功"
        case .error:
            return "请求失败"
        case .parameterError:
            return "参数错误"
        case .userExist:
            return "用户已存在"
        case .userNotExist:
            return "用户不存在"
        case .passwordError:
            return "密码错误"
        case .tokenExpire:
            return "授权已失效，请重新登录"
        case .tokenNotExist:
            return "授权令牌不能为空"
        case .powerOutOrder:
            return "当前订单没有访问权限"
        }
    }
}

public struct ResponseError: Debuggable {
    
    public var reason: String {
        return message
    }
    
    
    public var identifier: String {
        return "requestFailed"
    }
    
    /// The validation failure
    public var message: String
    
    /// Key path the validation error happened at
    public var code: ResponseCode
    
    /// Create a new JWT error
    public init(code: ResponseCode = .error,message: String? = nil) {
        self.message = message ?? code.desc
        self.code = code
    }

}
