//
//  AccessContainer.swift
//  App
//
//  Created by spectator Mr.Z on 2018/10/19.
//

import Foundation
import Vapor

struct AccessContainer: BaseValueObject {
    
    var accessToken: String
    var userID:String?
    
    init(accessToken: String,userID: String? = nil) {
        self.accessToken = accessToken
        self.userID = userID
    }
}
