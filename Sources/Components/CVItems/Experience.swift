import Foundation

public struct Experience: Codable, Identifiable, Hashable {
    
    let project: Project
    let company: Company
    let period: Period
    let role: Role
    let techs: [Tech]
    let descriptions: [String]
    
    public var id: String {
        "\(company.rawValue)-\(project.rawValue)-\(role.rawValue)-\(period.id)"
    }
    
    public init(project: Project,
                company: Company,
                period: Period,
                role: Role,
                techs: [Tech],
                descriptions: [String]) {
        self.project = project
        self.company = company
        self.period = period
        self.role = role
        self.techs = techs
        self.descriptions = descriptions
    }
}

