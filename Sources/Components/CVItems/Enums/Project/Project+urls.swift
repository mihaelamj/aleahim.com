import Foundation

public extension Project {
    var urls: [URL]? {
        switch self {
        case .tito:
            return nil
        case .wogibtswas:
            return  [
                URL(string:"https://itunes.apple.com/de/app/wogibtswas.at-aktionen-angebote/id771962700")!,
                URL(string: "https://www.wogibtswas.at")!
               ]
        case .bladesoho:
            return [URL(string: "https://www.bladesoho.co.uk")!]
        case .coachlette:
            return nil
        case .kindergarten:
            return nil
        case .whatt:
            return nil
        case .christresources:
            return [URL(string: "https://itunes.apple.com/us/app/bible-study-tools-christian/id600610494")!]
        case .consumr:
            return [URL(string: "https://x.com/purchxapp")!]
        case .qrcode:
            return [URL(string: "https://itunes.apple.com/us/app/qr-code-reader-and-scanner/id388175979")!]
        case .shopsavvy:
            return [URL(string: "https://itunes.apple.com/us/app/shop-savvy-barcode-scanner/id338828953")!]
        case .birthdayrama:
            return [URL(string: "https://www.producthunt.com/products/birthdayrama")!]
        case .huxly:
            return nil
        case .breckWorld:
            return nil
        case .servicepal:
            return [URL(string: "https://servicepal.com")!]
        case .wheelsup:
            return [
                URL(string: "https://wheelsup.com")!,
                URL(string: "https://itunes.apple.com/us/app/wheels-up/id956615077")!
            ]
        case .budtz:
            return nil
        case .birch:
            return [URL(string: "https://www.birchfinance.com")!]
        case .zumiez:
            return [
                URL(string: "https://www.zumiez.com")!,
                URL(string: "https://apps.apple.com/app/apple-store/id1163863113?pt=118023521&ct=1m2501_web_header_rbn_v")!
            ]
        case .responsumchat:
            return nil
        case .germanProject:
            return nil
        case .irobot:
            return [
                URL(string: "https://www.irobot.com")!,
                URL(string: "https://apps.apple.com/us/app/irobot-home/id101201444")!
            ]
        }
    }
}
