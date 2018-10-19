//
//  String+Extension.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/17.
//

import Foundation
import Vapor
import Crypto

extension String {
    
    func hashString(_ req: Request) throws -> String {
        return try req.make(BCryptDigest.self).hash(self)
    }
    
    func isAccount() -> (Bool,String) {
        if count < AccountMinCount {
            return (false,"账号长度不足")
        }
        
        if count > AccountMaxCount {
            return (false,"账号长度超出")
        }
        return (true,"账号符合")
    }
    
    func isPhone() -> (Bool,String) {
        
        if !self.isPurnInt() {
            return (false,"手机号码不正确")
        }
        
        if count == PhoneCount {
            return (true,"账号符合")
        }
        return (false,"手机号码不正确")
    }
    
    func isPassword() -> (Bool,String) {
        if count < passwordMinCount {
            return (false,"密码长度不足")
        }
        
        if count > PasswordMaxCount {
            return (false,"密码长度超出")
        }
        return (true,"密码符合")
    }
    
    func isPurnInt() -> Bool {
        
        let scan: Scanner = Scanner(string: self)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    // MARK: - String 转 Int
    public func intValue() -> Int {
        
        
        //    if let i = Int(text) {
        //        return i
        //    } else {
        //        return 0
        //    }
        let n = NumberFormatter().number(from: self)
        if let num = n {
            let totalPrice = Int(truncating: num)
            return totalPrice
        } else {
            return 0
        }
    }
    
    var int : Int {
        let n = NumberFormatter().number(from: self)
        if let num = n {
            let totalPrice = Int(truncating: num)
            return totalPrice
        } else {
            return 0
        }
    }
}
