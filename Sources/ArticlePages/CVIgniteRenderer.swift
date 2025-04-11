import Foundation
import Ignite
import CVBuilder

struct CVIgniteRenderer {
    let cv: CV
    
    private func formatDate(_ date: Period.SimpleDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let calendar = Calendar.current
        let components = DateComponents(year: date.year, month: date.month)
        let actualDate = calendar.date(from: components)!
        return formatter.string(from: actualDate)
    }
    
    var body: some HTML {
        Article {
            // Header with name and title
            Header {
                Text(cv.name)
                    .font(.title1)
                
                Text(cv.title)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            // Contact Information
            Section {
                Text(cv.contactInfo.email)
                Text(cv.contactInfo.phone)
                Text(cv.contactInfo.location)
                
                if let linkedIn = cv.contactInfo.linkedIn {
                    Link("LinkedIn", target: linkedIn)
                }
                
                if let github = cv.contactInfo.github {
                    Link("GitHub", target: github)
                }
                
                if let website = cv.contactInfo.website {
                    Link("Website", target: website)
                }
            }
            .margin(.vertical, 20)
            
            // Summary
            Section {
                Text("Summary")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(cv.summary)
            }
            .margin(.bottom, 20)
            
            // Experience
            Section {
                Text("Experience")
                    .font(.title3)
                    .fontWeight(.bold)
                
                ForEach(cv.experience) { experience in
                    Section {
                        Text(experience.company.name)
                            .font(.title4)
                            .fontWeight(.bold)
                        
                        Text(experience.role.title)
                            .font(.title5)
                        
                        Text("\(formatDate(experience.period.start)) - \(formatDate(experience.period.end))")
                            .foregroundStyle(.secondary)
                        
                        ForEach(experience.projects) { project in
                            Section {
                                Text(project.project.name)
                                    .fontWeight(.semibold)
                                
                                List {
                                    ForEach(project.project.descriptions) { description in
                                        ListItem(description)
                                    }
                                }
                                .listStyle(.unordered)
                                .margin(.leading, 20)
                                
                                if !project.project.techs.isEmpty {
                                    Section {
                                        ForEach(project.project.techs) { tech in
                                            Badge(tech.name)
                                                .margin(.trailing, 5)
                                        }
                                    }
                                }
                            }
                            .margin(.leading, 20)
                        }
                    }
                    .margin(.bottom, 20)
                }
            }
            .margin(.bottom, 20)
            
            // Education
            Section {
                Text("Education")
                    .font(.title3)
                    .fontWeight(.bold)
                
                ForEach(cv.education) { education in
                    Section {
                        Text(education.institution)
                            .font(.title4)
                            .fontWeight(.bold)
                        
                        Text(education.degree)
                        
                        Text("\(education.startYear) - \(education.endYear)")
                            .foregroundStyle(.secondary)
                    }
                    .margin(.bottom, 10)
                }
            }
            .margin(.bottom, 20)
            
            // Skills
            Section {
                Text("Skills")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Section {
                    ForEach(cv.skills) { skill in
                        Badge(skill.name)
                            .margin(.trailing, 5)
                    }
                }
            }
        }
        .padding(.vertical, 40)
        .container(.large)
        .margin(.horizontal, .auto)
    }
} 
