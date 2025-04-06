import Foundation

enum Project: String, CaseIterable, Codable, Identifiable, Hashable {
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
    case zumiez
    case responsumchat
    case irobot
    
    var id: String { self.rawValue }
}
