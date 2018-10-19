//
//  logger.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor
import SwiftyBeaverProvider

public func setupLogger(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    // Setup your destinations
    let console = ConsoleDestination()
    console.minLevel = .verbose // update properties according to your needs
    //
    let fileDestination = FileDestination()
    let filePath = try StringUtils.localLogRootDir(at: DirPath.LogPath.info, env: env)
    
    fileDestination.logFileURL = URL(fileURLWithPath: filePath)
    fileDestination.minLevel = .verbose
    fileDestination.format = "[$Dyyyy-MM-dd HH:mm:ss.SSS $d $L] : $M"
    
    //    // Register the logger
    services.register(SwiftyBeaverLogger(destinations: [console, fileDestination]), as: Logger.self)
    //
    //    // Optional
    config.prefer(SwiftyBeaverLogger.self, for: Logger.self)
}
