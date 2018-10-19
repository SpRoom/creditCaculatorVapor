//
//  ThrowsMiddlewware.swift
//  App
//
//  Created by spectator Mr.Z on 2018/8/17.
//

import Vapor

public final class ThrowsMiddleware :Middleware, ServiceType {
    
    
    
    public static func makeService(for worker: Container) throws -> ThrowsMiddleware {
        return try .thconfig(environment: worker.environment, log: worker.make())
    }
    
    /// Create a default `ErrorMiddleware`. Logs errors to a `Logger` based on `Environment`
    /// and converts `Error` to `Response` based on conformance to `AbortError` and `Debuggable`.
    ///
    /// - parameters:
    ///     - environment: The environment to respect when presenting errors.
    ///     - log: Log destination.
    public static func thconfig(environment: Environment, log: Logger) -> ThrowsMiddleware {
        /// Structure of `ErrorMiddleware` default response.
        struct ThrowsResponse: Encodable {
            /// Always `true` to indicate this is a non-typical JSON response.
            var error: Bool
            
            /// The reason for the error.
            var reason: String
            
            var code : Int
            var msg: String
            var data: String = ""
        }
        
        return .init { req, error in
            // log the error
            log.report(error: error, verbose: !environment.isRelease)
            
            // variables to determine
            let status: HTTPResponseStatus
            let reason: String
            let headers: HTTPHeaders
            
            let msg: String
            let code: Int
            
            // inspect the error type
            switch error {
            case let abort as AbortError:
                // this is an abort error, we should use its status, reason, and headers
                reason = abort.reason
                status = abort.status
                headers = abort.headers
                msg = "异常终止"
                code = 404
            case let validation as ValidationError:
                // this is a validation error
                reason = validation.reason
                status = .badRequest
                headers = [:]
                msg = validation.reason
                code = 1001
            case let resp as ResponseError:
                reason = resp.reason
                status = .ok
                headers = [:]
                msg = resp.message
                code = resp.code.rawValue
            case let debuggable as Debuggable where !environment.isRelease:
                // if not release mode, and error is debuggable, provide debug
                // info directly to the developer
                reason = debuggable.reason
                status = .internalServerError
                headers = [:]
                msg = debuggable.reason
                code = 100001
            default:
                // not an abort error, and not debuggable or in dev mode
                // just deliver a generic 500 to avoid exposing any sensitive error info
                reason = "Something went wrong."
                status = .internalServerError
                headers = [:]
                msg = "未知错误"
                code = 100002
            }
            
            // create a Response with appropriate status
            let res = req.makeResponse(http: .init(status: status, headers: headers))
            
            // attempt to serialize the error to json
            do {
                let errorResponse = ThrowsResponse(error: true, reason: reason, code: code, msg: msg, data: "")
                res.http.body = try HTTPBody(data: JSONEncoder().encode(errorResponse))
                res.http.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf-8")
            } catch {
                res.http.body = HTTPBody(string: "Oops: \(error)")
                res.http.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
            }
            return res
        }
    }
    
    /// Error-handling closure.
    private let closure: (Request, Error) -> (Response)
    
    /// Create a new `ErrorMiddleware`.
    ///
    /// - parameters:
    ///     - closure: Error-handling closure. Converts `Error` to `Response`.
    public init(_ closure: @escaping (Request, Error) -> (Response)) {
        self.closure = closure
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        let response: Future<Response>
        do {
            response = try next.respond(to: request)
        } catch {
            response = request.eventLoop.newFailedFuture(error: error)
        }
        
        return response.mapIfError { error in
            return self.closure(request, error)
        }
    }
}
