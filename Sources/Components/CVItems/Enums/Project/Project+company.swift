import Foundation

public extension Project {
    var company: Company {
        switch self {
        case .tito:
            return .undabot
        case .wogibtswas:
            return .undabot
        case .bladesoho:
            return .undabot
        case .coachlette:
            return .undabot
        case .kindergarten:
            return .token
        case .whatt:
            return .token
        case .christresources:
            return .token
        case .consumr:
            return .purch
        case .qrcode:
            return .purch
        case .shopsavvy:
            return .purch
        case .birthdayrama:
            return .masinerija
        case .huxly:
            return .masinerija
        case .breckWorld:
            return .cherishingStudio
        case .servicepal:
            return .cherishingStudio
        case .wheelsup:
            return .cherishingStudio
        case .budtz:
            return .cherishingStudio
        case .birch:
            return .cherishingStudio
        case .zumiez:
            return .iolap
        case .responsumchat:
            return .iolap
        case .germanProject:
            return .codeweaver
        case .irobot:
            return .iolap
        }
    }
}
