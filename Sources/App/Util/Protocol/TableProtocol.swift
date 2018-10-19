//
//  TableProtocol.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import FluentMySQL
import Vapor

public typealias BaseSQLModel = MySQLModel & MySQLMigration & Content

let tableScheme = "cc_"

extension MySQLModel {
    
    static var entity: String {return "\(tableScheme)\(self.name)s"}
}
