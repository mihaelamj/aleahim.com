import Foundation

public enum Company: String, CaseIterable, Codable, Identifiable, Hashable {
    case undabot
    case token
    case purch
    case masinerija
    case cherishingStudio
    case iolap
    case codeweaver
    case personal
    case germanCo
    
    public var id: String { self.rawValue }
    
    public var name: String {
        switch self {
        case .undabot: return "Undabot"
        case .token: return "Token"
        case .purch: return "Purch"
        case .masinerija: return "Masinerija"
        case .cherishingStudio: return "Cherishing Studio"
        case .iolap: return "iOLAP"
        case .codeweaver: return "Code Weaver"
        case .personal: return "Personal Projects"
        case .germanCo: return "Anonymous EU Company"
        }
    }
}
