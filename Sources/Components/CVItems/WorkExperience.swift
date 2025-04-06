import Foundation

public struct WorkExperience: Codable, Identifiable, Hashable {
    public let id: UUID
    public let company: Company
    public let role: Role
    public let period: Period
    public let projects: [Project]
    
    public init(
        id: UUID = UUID(),
        company: Company,
        role: Role,
        period: Period,
        projects: [Project]
    ) {
        self.id = id
        self.company = company
        self.role = role
        self.period = period
        self.projects = projects
    }
    
    // Helper method to get formatted date range
    public var formattedDateRange: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        let startMonth = period.start.month
        let startYear = period.start.year
        let endMonth = period.end.month
        let endYear = period.end.year
        
        var startComponents = DateComponents()
        startComponents.month = startMonth
        startComponents.year = startYear
        
        var endComponents = DateComponents()
        endComponents.month = endMonth
        endComponents.year = endYear
        
        let calendar = Calendar.current
        if let startDate = calendar.date(from: startComponents),
           let endDate = calendar.date(from: endComponents) {
            return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
        }
        
        return "\(startMonth)/\(startYear) - \(endMonth)/\(endYear)"
    }
}
