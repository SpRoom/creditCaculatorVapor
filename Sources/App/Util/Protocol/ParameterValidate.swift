//
//  ParameterValidate.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/18.
//

import Foundation
import Vapor

public typealias validateTuple = (Bool,String)
protocol ParameterValidate {
    func validation() -> validateTuple
}

extension ParameterValidate {
    
    func infoRetrun(errMsg: String) -> validateTuple {
        let isPass = speaceString(errMsg)
        return (isPass,isPass ? "验证成功" : errMsg)
    }
}

extension ParameterValidate {
    
    func validateSuccess(for req: Request) throws -> Future<Response>? {
        
        let valid = self.validation()
        
        if !valid.0 {
            return try ResponseJSON<Empty>(status: ResponseCode.parameterError, message: valid.1).encode(for: req)
        }
        return nil
    }
}
