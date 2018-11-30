// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "creditCaculator",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🔵 Swift ORM (queries, models, relations, etc) built on Mysql.
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        
        // Auth
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"),
        // vapor server
        .package(url: "https://github.com/vapor/crypto.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/redis.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/multipart.git", from: "3.0.0"),
        // log format
        .package(url: "https://github.com/vapor-community/swiftybeaver-provider.git", from: "3.1.0"),
        .package(url:"https://github.com/malcommac/SwiftDate.git",from: "5.0.13")
    ],
    targets: [
        .target(name: "App", dependencies: ["FluentMySQL", "Vapor","Authentication",
                                            "Crypto",
                                            "Redis",
                                            "Multipart",
                                            "SwiftyBeaverProvider",
            "SwiftDate"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

