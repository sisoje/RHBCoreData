// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "RHBCoreData",
    platforms: [
        .macOS(.v10_12), .iOS("10.3")
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RHBCoreData",
            targets: ["RHBCoreData"]
        ),
        .library(
            name: "RHBCoreDataTestUtilities",
            targets: ["RHBCoreDataTestUtilities"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/sisoje/RHBFoundation", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RHBCoreData",
            dependencies: ["RHBFoundation"],
            path: "Sources"
        ),
        .target(
            name: "RHBCoreDataTestUtilities",
            dependencies: ["RHBFoundation", "RHBCoreData"],
            path: "TestUtilities"
        ),
        .testTarget(
            name: "RHBCoreDataTests",
            dependencies: ["RHBFoundation", "RHBCoreData", "RHBFoundationTestUtilities", "RHBCoreDataTestUtilities"],
            path: "Tests"
        )
    ]
)
