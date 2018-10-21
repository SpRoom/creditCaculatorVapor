//
//  BillController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/21.
//

import Foundation
import Vapor

struct BillController {
    
    /// 查询自己所有的账单
    ///
    /// - Parameter
    /// - Returns: 账单列表
    /// - Throws:
    func bills(_ req: Request) throws -> Future<Response> {
        
        let billModel = BillModel()
        
        return try billModel.bills(req: req).flatMap { (bills) in
            
            let json = ResponseJSON(data: bills)
            return try VaporResponseUtil.makeResponse(req: req, vo: json)
        }
        
    }
}
