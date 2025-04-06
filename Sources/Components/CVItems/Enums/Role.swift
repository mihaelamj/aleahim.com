import Foundation

enum Role: String, CaseIterable, Codable, Identifiable {
    case junior
    case mid
    case senior
    
    var name: String {
        switch self {
        case .junior:
            return "Junior iOS Developer"
        case .mid:
            return "Mid iOS Developer"
        case .senior:
            return "Senior iOS Developer"
        }
    }
    
    var id: String { self.rawValue }
}

