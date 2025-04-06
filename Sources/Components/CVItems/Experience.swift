import Foundation

public struct Experience: Codable, Identifiable, Hashable {
    
    let projects: [Project]
    
    public var id: String {
        "experience"
    }
    
    public init(projects: [Project]) {
        self.projects = Self.assebleProjects(projects)
    }
    
    private static func assebleProjects(_ projects: [Project]) -> [Project] {
        return []
    }
}

