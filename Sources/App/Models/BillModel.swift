//
//  BillModel.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor
import FluentMySQL
import Fluent
import SwiftDate


struct BillModel {
    
    /// 查询自己所有的账单
    ///
    /// - Parameter
    /// - Returns: 账单列表
    /// - Throws: 
    func bills(req: Request) throws -> Future<[PaymentBill]> {
        
        let userid = try req.authed(User.self)!.userID
        
        return PaymentBill.query(on: req).filter(\.userID == userid).sort(\.reimnursementDate, .ascending).all().flatMap { (bills)  in
            return req.future(bills)
        }
        
    }
    
}
