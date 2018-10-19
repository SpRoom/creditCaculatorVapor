//
//  StringTool.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/18.
//

import Foundation
import Vapor

/// 字符串非空判断（ nil "") 均为 true
func isNullStr(_ text: String?) -> Bool {
    guard let text = text else {
        return true
    }
    
    if text.count == 0 {
        return true
    }
    
    return false
}

/// 判断是不是空字符串 ("") 为 true
func speaceString(_ text: String) -> Bool {
    
    if text.count == 0 {
        return true
    }
    return false
}

class StringUtils {
    
    static func localRootDir(at path: String, env: Environment) throws -> String {
        
        let workDir = DirectoryConfig.detect().workDir
        
        let envPath = env.isRelease ? "":"debug_"
        let addPath = "\(envPath)\(path)"
        
        var localPath = ""
        if (workDir.contains("ubuntu")) {
            localPath = "/home/ubuntu/image/\(addPath)"
        }else if workDir.contains("apple") {
            localPath = "/Users/apple/Desktop/Tang/vapor/\(addPath)"
        } else {
            localPath = "\(workDir)\(addPath)"
        }
        
        let manager = FileManager.default
        if !manager.fileExists(atPath: localPath) { //不存在则创建
            try manager.createDirectory(atPath: localPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return localPath
    }
    
    
    static func localLogRootDir(at path: String, env: Environment) throws -> String {
        
        let workDir = DirectoryConfig.detect().workDir
        
        let envPath = env.isRelease ? "":"debug_"
        let addPath = "\(envPath)log"
        
        var localPath = ""
        if (workDir.contains("ubuntu")) {
            localPath = "/home/ubuntu/image/\(addPath)"
        }else if workDir.contains("apple") {
//            localPath = "/tmp/ticket/\(addPath)"
//            localPath = "/tmp/ticket/\(addPath)"
            localPath = "/Users/apple/Desktop/Tang/vapor/\(addPath)"
        } else {
            localPath = "\(workDir)\(addPath)"
        }
        
        let manager = FileManager.default
        if !manager.fileExists(atPath: localPath) { //不存在则创建
            try manager.createDirectory(atPath: localPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        localPath = localPath + "/\(env.name)_\(path).log"
        return localPath
    }
}
