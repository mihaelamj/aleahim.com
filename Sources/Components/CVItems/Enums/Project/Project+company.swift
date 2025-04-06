import Foundation

public extension Project {
    var company: Company {
        switch self {
        case .birthdayrama:
            return .masinerija
        case .tito:
            return .undabot
        case .coachlette:
            return .undabot
        case .wogibtswas:
            return .undabot
        case .bladesoho:
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
        case .huxly:
            return .masinerija
        case .servicepal:
            return .cherishingStudio
        case .budtz:
            return .cherishingStudio
        case .wheelsup:
            return .cherishingStudio
        case .birch:
            return .token
        case .zumiez:
            return .iolap
        case .responsumchat:
            return .iolap
        case .irobot:
            return .iolap
        case .germanProject:
            return .germanCo
        case .breckWorld:
            return .cherishingStudio
        }
    }
}
