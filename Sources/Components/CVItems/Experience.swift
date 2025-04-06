import Foundation

struct ExperienceItem: Codable, Identifiable {
    let project: Project
    let company: Company
    let period: Period
    let role: Role
    let techs: [Tech]
    let urls: [URL]?
    let descriptions: [String]
    
    var id: String {
        "\(company.rawValue)-\(project.rawValue)-\(role.rawValue)-\(period)"
    }
}

