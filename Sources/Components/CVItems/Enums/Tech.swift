import Foundation

enum Tech: String, CaseIterable, Codable, Identifiable, Hashable {
    case swift
    case swiftui
    case objc
    case uikit
    case appkit
    case uiincode
    case cocapods
    case carthage
    case swiftpm
    case openapi
    case rest
    case graphql
    case coretext
    case coregraphics
    case coreanimation
    case autolayout
    case afnet
    case structconcurrency
    
    var name: String {
        switch self {
        case .swift: return "Swift"
        case .swiftui: return "SwiftUI"
        case .objc: return "Objective-C"
        case .uikit: return "UIKit"
        case .appkit: return "AppKit"
        case .uiincode: return  "UI in code"
        case .cocapods: return "CocoaPods"
        case .carthage: return "Carthage"
        case .swiftpm: return "Swift Package Manager"
        case .openapi: return "OpenAPI"
        case .rest: return "REST"
        case .graphql: return "GraphQL"
        case .coretext: return "CoreText"
        case .coregraphics: return "CoreGraphics"
        case .coreanimation: return "CoreAnimation"
        case .autolayout: return "AutoLayout"
        case .afnet: return "AFNetworking"
        case .structconcurrency: return "Structured Concurrency"
        }
    }
    
    var id: String { self.rawValue }
}

