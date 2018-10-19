
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
   
    try registerProvider(&services, &config)
    
    
    /// Register routes to the router
    try routers(&services)
    
    /// Register middleware
    try setupMiddlewares(&services)
    
    
    try setupLogger(&config, &env, &services)
    
    /// Register the configured SQLite database to the database config.
    setupSQL(env, &services)
    
    
    //    try services.register(AuthenticationProvider())
    
    registerFlunet(&services)
   
    
//    setup(host: "0.0.0.0", port: 9000, services: &services)

}
