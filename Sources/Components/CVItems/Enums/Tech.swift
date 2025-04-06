import Foundation

enum Tech: String, CaseIterable, Codable, Identifiable, Hashable {
    case swift
    case swiftui
    case objc
    case uikit
    case appkit
    
    var name: String {
        switch self {
        case .swift:
            return "Swift"
        case .swiftui:
            return "SwiftUI"
        case .objc:
            return "Objective-C"
        case .uikit:
            return "UIKit"
        case .appkit:
            return "AppKit"
        }
    }
    
    var id: String { self.rawValue }
}

