import Foundation

enum Company: String, CaseIterable, Codable, Identifiable {
    case undabot
    case token
    case purch
    case masinerija
    case cherishingStudio
    case iolap
    case codeweaver
    
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .undabot:
            return "Undabot"
        case .token:
            return "Token"
        case .purch:
            return "Purch"
        case .masinerija:
            return "Masinerija"
        case .cherishingStudio:
            return "Cherishing Studio"
        case .iolap:
            return "iOLAP"
        case .codeweaver:
            return "Code Weaver"
        }
    }
}
