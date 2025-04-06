import Foundation

public enum Role: String, CaseIterable, Codable, Identifiable, Hashable {
    case junior
    case mid
    case senior
    
    public var name: String {
        switch self {
        case .junior:
            return "Junior iOS Developer"
        case .mid:
            return "Mid iOS Developer"
        case .senior:
            return "Senior iOS Developer"
        }
    }
    
    public var id: String { self.rawValue }
}

