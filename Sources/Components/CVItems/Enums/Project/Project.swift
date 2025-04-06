import Foundation

public enum Project: String, CaseIterable, Codable, Identifiable, Hashable {
    case tito
    case coachlette
    case wogibtswas
    case bladesoho
    case kindergarten
    case whatt
    case christresources
    case consumr
    case qrcode
    case shopsavvy
    case birthdayrama
    case huxly
    case servicepal
    case budtz
    case wheelsup
    case birch
    case zumiez
    case responsumchat
    case irobot
    case germanProject
    case breckWorld
    
    public var id: String { self.rawValue }
    
    public var name: String {
        switch self {
        case .tito: return "Tito"
        case .coachlette: return "Coachlette App"
        case .wogibtswas: return "wogibtswas.at"
        case .bladesoho: return "Blade Soho App"
        case .kindergarten: return "Kindergarten (Cancelled)"
        case .whatt: return "Whatt - social network"
        case .christresources: return "Christian Resources"
        case .consumr: return "Consumr App"
        case .qrcode: return "QR Code Reader and Scanner App"
        case .shopsavvy: return "Shopsavvy App"
        case .birthdayrama: return "Birthdayrama App"
        case .huxly: return "Huxly App"
        case .servicepal: return "ServicePal"
        case .budtz: return "Budtz Innovation"
        case .zumiez: return " ZUMIEZ Stash App"
        case .responsumchat: return "AI Chat SDK"
        case .irobot: return "iRobot App"
        case .wheelsup: return "Wheels Up"
        case .birch: return "Birch Finance"
        case .germanProject: return "Anonymous Big EU Project"
        case .breckWorld: return "Breck World"
        }
    }
}

