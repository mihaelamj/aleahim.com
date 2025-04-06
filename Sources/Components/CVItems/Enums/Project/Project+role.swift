import Foundation

public extension Project {
    var role: Role {
        switch self {
        case .tito:
            return .junior
        case .wogibtswas:
            return .junior
        case .bladesoho:
            return .junior
        case .coachlette:
            return .junior
        case .kindergarten:
            return .mid
        case .whatt:
            return .mid
        case .christresources:
            return .mid
        case .consumr:
            return .mid
        case .qrcode:
            return .mid
        case .shopsavvy:
            return .mid
        case .birthdayrama:
            return .senior
        case .huxly:
            return .senior
        case .breckWorld:
            return .senior
        case .servicepal:
            return .senior
        case .wheelsup:
            return .senior
        case .budtz:
            return .senior
        case .birch:
            return .junior
        case .zumiez:
            return .senior
        case .responsumchat:
            return .senior
        case .germanProject:
            return .senior
        case .irobot:
            return .senior
        }
    }
}
