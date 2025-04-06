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
            return []
        case .consumr:
            return []
        case .qrcode:
            return []
        case .shopsavvy:
            return []
        case .birthdayrama:
            return ["A fun way to share your birthday wishes with friends and family."]
        case .huxly:
            return []
        case .breckWorld:
            return []
        case .servicepal:
            return []
        case .wheelsup:
            return []
        case .budtz:
            return []
        case .birch:
            return []
        case .zumiez:
            return []
        case .responsumchat:
            return []
        case .germanProject:
            return []
        case .irobot:
            return []
        }
    }
}
