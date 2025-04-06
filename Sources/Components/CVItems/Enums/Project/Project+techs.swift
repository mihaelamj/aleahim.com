import Foundation

public extension Project {
    var techs: [Tech] {
        switch self {
        case .tito:
            return [.objc, .uikit, .uiincode, .coretext, .coregraphics, .coreanimation, .carthage, .inAppPurchase]
        case .wogibtswas:
            return [.objc, .uikit, .uiincode, .afnet, .autolayout, .rest, .carthage]
        case .bladesoho:
            return [.objc, .uikit, .uiincode, .afnet, .autolayout, .rest, .carthage]
        case .coachlette:
            return [.objc,.uikit,.uiincode, .afnet, .autolayout, .rest, .carthage]
        case .kindergarten:
            return [.objc, .uikit, .uiincode, .coretext, .coregraphics, .coreanimation, .cocapods, .autolayout]
        case .whatt:
            return [.objc, .uikit, .uiincode, .coretext, .coregraphics, .coreanimation, .cocapods, .rest]
        case .christresources:
            return [.objc, .uikit, .uiincode, .avfoundation, .coregraphics]
        case .consumr:
            return [.objc, .uikit, .uiincode, .pushNotifications, .autolayout, .afnet, .coreanimation, .rest]
        case .qrcode:
            return [.objc, .uikit, .uiincode, .barcodes, .autolayout, .coreanimation]
        case .shopsavvy:
            return [.swift, .uikit, .uiincode, .barcodes, .autolayout, .coreanimation, .rest]
        case .birthdayrama:
            return [.swift, .uikit, .uiincode, .coredata]
        case .huxly:
            return [.swift, .uikit, .uiincode, .autolayout, .rest]
        case .breckWorld:
            return []
        case .servicepal:
            return [.objc, .uikit, .uiincode, .coredata, .rest]
        case .wheelsup:
            return [.objc, .swift, .uikit, .uiincode, .pushNotifications, .rest, .afnet, .openapi]
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
