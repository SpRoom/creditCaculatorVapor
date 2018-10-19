//
//  VaporResponseUtil.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/24.
//

import Foundation
import Vapor

class VaporResponseUtil {

    static func makeResponse<T: Content>(req: Request, vo: T) throws -> Future<Response> {
        
        let logger = try req.make(Logger.self)
        
        logger.debug("api response - \(vo)")
        
        return try vo.encode(for: req)
    }
    
//    static func makeResponse<T>(req: Request, vo: ResponseVO<[T]>) throws -> Future<Response> {
//
//        let logger = try req.make(Logger.self)
//
//        logger.debug("\(vo)")
//
//        return try vo.encode(for: req)
//    }
}
