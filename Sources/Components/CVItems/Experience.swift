import Foundation

struct Experience: Codable, Identifiable, Hashable {
    
    let project: Project
    let company: Company
    let period: Period
    let role: Role
    let techs: [Tech]
    let urls: [URL]?
    let descriptions: [String]
    
    var id: String {
        "\(company.rawValue)-\(project.rawValue)-\(role.rawValue)-\(period.id)"
    }
    
    public init(project: Project,
                company: Company, period:
                Period, role: Role,
                techs: [Tech],
                urls: [URL]? = nil,
                descriptions: [String]) {
        self.project = project
        self.company = company
        self.period = period
        self.role = role
        self.techs = techs
        self.urls = urls
        self.descriptions = descriptions
    }
}

