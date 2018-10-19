//
//  AuthContainer.swift
//  APIErrorMiddleware
//
//  Created by Jinxiansen on 2018/6/1.
//

import Vapor

public struct AuthContainer: Content {

    let accessToken: AccessToken.Token
    let expiresIn: TimeInterval
    let refreshToken: RefreshToken.Token
    
    init(accessToken: AccessToken,refreshToken: RefreshToken) {
        self.accessToken = accessToken.tokenString
        self.expiresIn = AccessToken.accessTokenExpirationInterval
        self.refreshToken = refreshToken.tokenString
    }

}

public struct RefreshTokenContainer: Content {
    
    let refreshToken: RefreshToken.Token

}





