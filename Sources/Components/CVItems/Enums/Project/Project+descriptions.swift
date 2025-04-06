import Foundation

public extension Project {
    var descriptions: [String] {
        switch self {
        case .tito:
            return [
                "iOS (iPad) book application about the life of Josip Broz Tito",
                "Objective-C, Cocoapods",
                "Implemented custom UI in code (from design sheets)",
                "CoreText custom page layouts"
            ]
        case .wogibtswas:
            return [
                "wogibtswas.at, Austria’s biggest \"what’s on offer\" portal.",
                "Objective-C, AFNetworking, REST services, Cocoapods",
                "Custom UI design in code"
            ]
        case .bladesoho:
            return [
                "Custom app for one of leading London hair salons",
                "Objective-C, AFNetworking, REST services, Cocoapods",
                "Implemented custom UI in code (from design sheets)"
            ]
        case .coachlette:
            return [
                "Custom app for a personal trainers and coaches",
                "Objective-C, AFNetworking, REST services, Cocoapods",
                "Implemented custom UI in code"
            ]
        case .kindergarten:
            return [
                "iOS app for Croatian company, for managing kindergartens",
                "Developed 90% of the app",
                "Designed REST APIs and implemented it in the app",
                "Implemented custom UI design code"
            ]
        case .whatt:
            return [
                "iOS app for social network",
                "Developer custom expandable TextView with links and tagging",
            ]
        case .christresources:
            return [
                "Universal iOS app (iPhone and iPad), for a client through ODesk",
                "Developed the application(100%)",
                "Created design in Sketch and implemented it in the application, dynamic UI for iPhone 4, iPhone 5, iPhone 6, iPhone 6 Plus and iPad",
                "Used Core Animation, Auto Layout, AFNetworking, remote audio streaming",
                "Client changed parts of the UI afterwards"
            ]
        case .consumr:
            return [
                "Adapting existing client application for iOS 8+",
                "Implemented detailed Gap Analysis for the application including iOS frontend and REST API backend differences",
                "Implemented custom UI design code (from design sheets)",
                "REST API implementation",
                "Used Core Animation, Auto Layout, AFNetworking, Push notifications"
                
            ]
        case .qrcode:
            return [
                "Objective-C, custom UI in code",
                "QR code scanning and creation",
                "Added custom sharing and feedback functionality"
            ]
        case .shopsavvy:
            return [
                "App for shopping and barcode scanning",
                "Developer in Swift, UIKit, AutoLayout",
                "Worked on parts of the app that include: barcode scanning, QR code scanning and creation, general bug fixing"
            ]
        case .birthdayrama:
            return [
                "A fun way to share your birthday wishes with friends and family",
                "Refactored the whole app",
                "Made a form factory for the app uses many screens with input fields",
                "Used the newest AutoLayout best practices"
            ]
        case .huxly:
            return [
                "Newsreader reimagined",
                "Added many functionalities and new screens in the app",
                "Login / Sign up / Forgot password screens (dynamic form screens)",
                "Demographics screens (dynamic radio control screens using CoreAnimation)",
                "Home and dynamic filter screens",
                "Sharing functionality"
            ]
        case .breckWorld:
            return [
                "Built app from scratch in Swift 4+",
                "Built UI in Code, UIKit, Auto Layout",
                "Implemented networking layer using URLSession",
                "ARKit integration"
            ]
        case .servicepal:
            return [
                "Added custom features usingObjective-C, UKit",
                "Dynamic Content Framework Developer - Designed and implemented a template-based dynamic content creation system that allowed for real-time content generation and updates without requiring app redeployment",
                "Increasing development efficiency by 35%"
            ]
        case .wheelsup:
            return [
                "Modernized and refactored legacy Objective-C codebase to Swift",
                "Improved maintainability and fixed bugs",
                "Simplified login flow to enhance user experience and reduce authentication friction",
                "Developed custom UIKit components to improve app performance and user interface"
            ]
        case .budtz:
            return [
                "Led the refactoring of a legacy iOS app’s UI and networking stack using modern Swift paradigms",
                "Reorganized the codebase into scalable, feature-driven modules to improve team velocity and onboarding"
            ]
        case .birch:
            return [
                "Refactored a large iOS app's UI and networking layer using modern Swift",
                "Implemented MVVM architecture with clean separation of concerns",
                "Built a comprehensive networking library with complete test coverage",
                "Organized code into feature-based modules",
                "Improved code quality through proper formatting, linting, and testing infrastructure"
            ]
        case .zumiez:
            return [
                "Worked on the Zumiez Stash app as a Senior iOS Engineer",
                "Created Swift network client code generator from OpenAPI specs",
                "Refactored legacy applications & unit-tested critical components",
                "Implemented a custom lightweight GraphQL client without external dependencies, featuring type-safe request handling,  efficient query utilities and custom GraphQL schema parsing and sophisticated error management",
                "Designed and implemented a modular filtering system with dynamic UI components, supporting complex data sorting and real-time updates"
            ]
        case .responsumchat:
            return [
                "Developed a cross-platform chat SDK for iOS and macOS using Swift and SwiftUI for AI chatbot",
                "Implemented real-time messaging, speech recognition, and UI components with modern architecture patterns",
                "Designed using modular architecture with 10+ local package handling UI styling, message management, socket communication, and speech recognition",
                "Built with Combine for reactive programming, protocol-oriented design, and comprehensive testing infrastructure",
                "Implemented platform-specific components with shared protocols ensuring consistent behavior"
            ]
        case .germanProject:
            return [
                "Refactored Client Backend OpenAPI Specs and Built a Swift Networking Package",
                "Reorganized and clarified existing OpenAPI specifications to better reflect backend capabilities and client requirements. Ensured consistency and accuracy across endpoints and models",
                 "Created a modular Swift package to encapsulate the networking logic, designed for clean separation of concerns, testability, and reuse across projects",
                  "Integrated Swift OpenAPI Generator to automatically generate type-safe API client code from OpenAPI specs, enabling seamless updates and minimizing manual maintenance",
                  "Streamlined the build process to regenerate client code automatically upon spec changes, aligning with CI/CD pipelines and reducing the risk of contract drift"
            ]
        case .irobot:
            return []
        }
    }
}
