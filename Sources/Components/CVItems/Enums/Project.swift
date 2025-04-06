import Foundation

enum Project: String, CaseIterable, Codable, Identifiable {
    case cachlette
    case tito
    case wogibtswas
    case bladesoho
    case kindergarten
    case whatt
    case chistresources
    case consumr
    case qrcode
    case shopsavvy
    case birthdayrama
    case huxly
    case servicepal
    case budtz
    case zumiez
    case responsumchat
    case irobot
    
    var id: String { self.rawValue }
}
