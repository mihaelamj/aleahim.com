//import Foundation
//import Ignite
//
//struct CVArticlePage: ArticlePage {
//    var body: some HTML {
//        Article {
//            // Header Section with Name and Title
//            Header {
//                Text(article.title)
//                    .font(.title1)
//                    .fontWeight(.bold)
//                    .margin(.bottom, .small)
//                
//                if let subtitle = article.metadata.description {
//                    Text(subtitle)
//                        .font(.title3)
//                        .color(.gray)
//                        .margin(.bottom, .medium)
//                }
//            }
//            
//            // Summary Section
//            Section {
//                Text(article.text)
//                    .lineSpacing(1.5)
//                    .margin(.bottom, .large)
//            }
//            
//            // Contact Info Section (parsing from the content)
//            Section {
//                Div {
//                    ForEach(article.text.split(separator: "\n").prefix(10)) { line in
//                        if line.contains("@") || line.contains("+") || line.contains("LinkedIn") || line.contains("GitHub") || line.contains("Website") {
//                            Text(String(line))
//                                .margin(.bottom, .xSmall)
//                        }
//                    }
//                }
//                .margin(.bottom, .large)
//            }
//            
//            // Experience Section
//            if article.text.contains("## EXPERIENCE") {
//                Section {
//                    H2("Experience")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .margin(.bottom, .medium)
//                    
//                    Div {
//                        // We'll extract and format the experience content from the article text
//                        let experienceContent = extractSection(from: article.text, section: "## EXPERIENCE", until: "## SKILLS")
//                        
//                        Text(experienceContent)
//                            .lineSpacing(1.5)
//                    }
//                    .margin(.bottom, .large)
//                }
//            }
//            
//            // Skills Section
//            if article.text.contains("## SKILLS") {
//                Section {
//                    H2("Skills")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .margin(.bottom, .medium)
//                    
//                    Div {
//                        let skillsContent = extractSection(from: article.text, section: "## SKILLS", until: nil)
//                        
//                        // Extract skills from the skills content (they're in pipe format: | Skill1 | Skill2 |)
//                        let skills = parseSkills(from: skillsContent)
//                        
//                        Div {
//                            ForEach(skills) { skill in
//                                Badge {
//                                    Text(skill)
//                                        .padding(.xSmall)
//                                }
//                                .margin(.xxSmall)
//                            }
//                        }
//                        .display(.flex)
//                        .flexWrap(.wrap)
//                    }
//                }
//            }
//            
//            // Footer with last updated info
//            Footer {
//                Divider()
//                    .margin(.vertical, .medium)
//                
//                HStack {
//                    Text("Last updated: ")
//                        .font(.small)
//                        .color(.gray)
//                    
//                    if let date = article.date {
//                        Text(date.formatted(date: .long, time: .omitted))
//                            .font(.small)
//                            .color(.gray)
//                    }
//                }
//                .margin(.top, .medium)
//            }
//        }
//        .padding(.vertical, .large)
//        .maxWidth(.large)
//        .margin(.horizontal, .auto)
//    }
//    
//    // Helper function to extract a section from the article text
//    func extractSection(from text: String, section: String, until nextSection: String?) -> String {
//        guard let sectionRange = text.range(of: section) else { return "" }
//        
//        let startIndex = text.index(sectionRange.upperBound, offsetBy: 1)
//        
//        let endIndex: String.Index
//        if let nextSection = nextSection, let nextSectionRange = text.range(of: nextSection, range: startIndex..<text.endIndex) {
//            endIndex = nextSectionRange.lowerBound
//        } else {
//            endIndex = text.endIndex
//        }
//        
//        return String(text[startIndex..<endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
//    }
//    
//    // Helper function to parse skills from the skills section
//    func parseSkills(from skillsText: String) -> [String] {
//        // Extract text between pipe characters and filter out empty strings
//        let skillLine = skillsText.components(separatedBy: .newlines)
//            .first(where: { $0.hasPrefix("- |") }) ?? ""
//        
//        return skillLine
//            .components(separatedBy: "|")
//            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//            .filter { !$0.isEmpty && $0 != "-" }
//    }
//}
