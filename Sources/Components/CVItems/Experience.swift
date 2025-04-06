import Foundation

public struct Experience: Codable, Identifiable, Hashable {
    
    let projects: [Project]
    
    public var id: String {
        "experience"
    }
    
    public init(projects: [Project]) {
        self.projects = Self.assembleProjects(projects)
    }
    
    private static func assembleProjects(_ projects: [Project]) -> [Project] {
        return []
    }
}

