import Foundation

public struct Period: Codable, Identifiable, Equatable, Hashable {
    public struct SimpleDate: Codable, Identifiable, Hashable, Equatable {
        public let month: Int
        public let year: Int
        
        public var id: String {
            "\(year)-\(String(format: "%02d", month))"
        }
    }

    public let start: SimpleDate
    public let end: SimpleDate

    public var id: String {
        "\(start.id)_to_\(end.id)"
    }
}
