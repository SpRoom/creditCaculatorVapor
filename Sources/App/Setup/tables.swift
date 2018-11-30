//
//  tables.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import FluentMySQL

public let mysqlHostname = "127.0.0.1"
public let mysqlPort = 3306
public let mysqlUsername = "root"
public let mysqlPassword = "root"
public let mysqlDatabase = "creditCaculator"

final class SQLConfig {


    func config() -> DatabasesConfig {
        
        var databases = DatabasesConfig()
        let mysql = MySQLDatabase(config: MySQLDatabaseConfig(hostname: mysqlHostname, port: mysqlPort, username: mysqlUsername, password: mysqlPassword, database: mysqlDatabase, characterSet: .utf8_general_ci, transport: .cleartext))
        
        databases.add(database: mysql, as: sqltype)
        databases.enableLogging(on: sqltype)
        
        return databases
    }
    
    
}


public func setupSQL(_ env: Environment, _ services: inout Services) {
    let sqlconfig = SQLConfig()
    if env.isRelease {
        print("start mysql release")
    } else {
        print("start mysql debug")
        
    }
    let databases = sqlconfig.config()
    services.register(databases)
}

public func registerFlunet(_ services: inout Services) {
    
    let migrations = registerTable()
    services.register(migrations)
}


fileprivate func registerTable() -> MigrationConfig {
    /// Configure migrations
    var migrations = MigrationConfig()
 
    migrations.add(model: AccessToken.self, database: sqltype)
    migrations.add(model: RefreshToken.self, database: sqltype)
    migrations.add(model: User.self, database: sqltype)
    
    migrations.add(model: Account.self, database: sqltype)
    migrations.add(model: AccountType.self, database: sqltype)
    migrations.add(model: ConsumLog.self, database: sqltype)
    migrations.add(model: ConsumSubType.self, database: sqltype)
    migrations.add(model: ConsumType.self, database: sqltype)
    migrations.add(model: Loan.self, database: sqltype)
    migrations.add(model: PaymentBill.self, database: sqltype)
    migrations.add(model: CreditConsumptionBill.self, database: sqltype)
    migrations.add(model: POSDevice.self, database: sqltype)
    
    return migrations
}
