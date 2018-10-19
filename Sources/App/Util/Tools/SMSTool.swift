//
//  SMSTool.swift
//  App
//
//  Created by spectator Mr.Z on 2018/9/3.
//

import Foundation

class SMSTool {
    
    public static let shared = SMSTool()
    
    let randomContentArr = ["0","1","2","3","4","5","6","7","8","9"]
    
    func randomNum(_ count: Int = 8) -> String {
        
        var uuid = ""
        
        for _ in 0..<count {
            
            
            #if os(Linux)
            let subscri = Int(random()%10)
            #else
            let subscri = Int(arc4random()%10)
            #endif
            
            let str = randomContentArr[subscri]
            uuid = uuid + str
        }
        
        return uuid
    }
    
}
