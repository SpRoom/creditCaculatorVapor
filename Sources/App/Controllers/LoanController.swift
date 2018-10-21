//
//  LoanController.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/20.
//

import Foundation
import Vapor

struct LoanController {
    
    func addLoan(_ req: Request, container: LoanContainer) throws -> Future<Response> {
        
        let loanModel = LoanModel()
        
        let name = container.name
        let lines = container.lines
        let reimsementDate = container.reimsementDate
        let borrowDate = container.borrowDate
        let moneystr = container.instaments
        
        return try loanModel.addLoan(req: req, name: name, lines: lines, reimsementDate: reimsementDate, borrowDate: borrowDate)
            .flatMap({ (loan)  in
                if let id = loan.id {
                    
                    return try loanModel.addBills(req: req, loanId: id, borrowDate: borrowDate, reimsementDate: reimsementDate, moneys: moneystr).flatMap({ (bills)  in
                        let json = ResponseJSON<Empty>(status: .success)
                        return try VaporResponseUtil.makeResponse(req: req, vo: json)
                    })
                    
                } else {
                   let json = ResponseJSON<Empty>(status: .error)
                    return try VaporResponseUtil.makeResponse(req: req, vo: json)
                }
            })
    }
}
