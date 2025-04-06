import Foundation

struct Period: Codable, Identifiable, Equatable, Hashable {
    struct SimpleDate: Codable, Identifiable, Hashable, Equatable {
        let month: Int
        let year: Int
        
        var id: String {
            "\(year)-\(String(format: "%02d", month))"
        }
    }

    let start: SimpleDate
    let end: SimpleDate

    var id: String {
        "\(start.id)_to_\(end.id)"
    }
}
