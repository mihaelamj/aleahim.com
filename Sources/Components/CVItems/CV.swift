import Foundation

public struct CV: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let title: String
    public let summary: String
    public let contactInfo: ContactInfo
    public let experience: [WorkExperience]
    public let education: [Education]
    public let skills: [Tech]
    
    public init(
        id: UUID = UUID(),
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        experience: [WorkExperience],
        education: [Education],
        skills: [Tech]
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.summary = summary
        self.contactInfo = contactInfo
        self.experience = experience
        self.education = education
        self.skills = skills
    }
    
    // Helper to organize projects by company
    public func projectsByCompany() -> [Company: [Project]] {
        var result: [Company: [Project]] = [:]
        
        for exp in experience {
            for project in exp.projects {
                if result[project.company] == nil {
                    result[project.company] = []
                }
                result[project.company]?.append(project)
            }
        }
        
        return result
    }
    
    // Helper to get unique skills from all projects
    public func allUniqueSkills() -> [Tech] {
        var uniqueSkills: Set<Tech> = []
        
        for exp in experience {
            for project in exp.projects {
                uniqueSkills.formUnion(project.techs)
            }
        }
        
        return Array(uniqueSkills).sorted { $0.name < $1.name }
    }
}


// Example usage
extension CV {
    public static func createFromProjects(
        name: String,
        title: String,
        summary: String,
        contactInfo: ContactInfo,
        education: [Education],
        projects: [Project]
    ) -> CV {
        // Group projects by company
        var experienceByCompany: [Company: (Role, Period, [Project])] = [:]
        
        for project in projects {
            let company = project.company
            
            if let existing = experienceByCompany[company] {
                // Determine highest role
                let highestRole = compareRoles(existing.0, project.role)
                
                // Extend the period if needed
                let start = compareSimpleDates(existing.1.start, project.period.start, pickEarlier: true)
                let end = compareSimpleDates(existing.1.end, project.period.end, pickEarlier: false)
                
                let newPeriod = Period(start: start, end: end)
                var updatedProjects = existing.2
                updatedProjects.append(project)
                
                experienceByCompany[company] = (highestRole, newPeriod, updatedProjects)
            } else {
                experienceByCompany[company] = (project.role, project.period, [project])
            }
        }
        
        // Convert to array of WorkExperience
        let experiences = experienceByCompany.map { company, details in
            WorkExperience(
                company: company,
                role: details.0,
                period: details.1,
                projects: details.2
            )
        }.sorted { exp1, exp2 in
            // Sort by end date (most recent first)
            if exp1.period.end.year > exp2.period.end.year { return true }
            if exp1.period.end.year < exp2.period.end.year { return false }
            return exp1.period.end.month > exp2.period.end.month
        }
        
        // Extract unique skills
        let allSkills = projects.flatMap { $0.techs }
        let uniqueSkills = Array(Set(allSkills)).sorted { $0.name < $1.name }
        
        return CV(
            name: name,
            title: title,
            summary: summary,
            contactInfo: contactInfo,
            experience: experiences,
            education: education,
            skills: uniqueSkills
        )
    }
    
    // Helper function to compare roles and return the higher one
    private static func compareRoles(_ role1: Role, _ role2: Role) -> Role {
        switch (role1, role2) {
        case (.junior, .mid), (.junior, .senior): return role2
        case (.mid, .senior): return role2
        case (.mid, .junior), (.senior, .junior), (.senior, .mid): return role1
        default: return role1 // Same roles
        }
    }
    
    // Helper function to compare SimpleDates
    private static func compareSimpleDates(_ date1: Period.SimpleDate, _ date2: Period.SimpleDate, pickEarlier: Bool) -> Period.SimpleDate {
        if date1.year < date2.year {
            return pickEarlier ? date1 : date2
        }
        if date1.year > date2.year {
            return pickEarlier ? date2 : date1
        }
        // Same year, compare months
        if date1.month < date2.month {
            return pickEarlier ? date1 : date2
        }
        return pickEarlier ? date2 : date1
    }
}
