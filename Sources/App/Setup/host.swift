//
//  host.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor

public func setup(host: String, port: Int, services: inout Services) {
    let serverConfiure = NIOServerConfig.default(hostname: host, port: port)
    services.register(serverConfiure)
}
