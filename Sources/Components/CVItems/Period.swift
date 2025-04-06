import Foundation

struct Period: Codable, Identifiable {
    struct SimpleDate: Codable, Identifiable {
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
