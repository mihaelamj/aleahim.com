import Foundation
import PDFKit

#if canImport(UIKit)
import UIKit

public class UIKitCVPDFGenerator {
    private let cv: CV
    private let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter size
    private let margin: CGFloat = 50
    private let defaultFont = UIFont.systemFont(ofSize: 11)
    private let headerFont = UIFont.boldSystemFont(ofSize: 16)
    private let subHeaderFont = UIFont.boldSystemFont(ofSize: 14)
    private let sectionFont = UIFont.boldSystemFont(ofSize: 12)
    private let normalFont = UIFont.systemFont(ofSize: 11)
    private let italicFont = UIFont.italicSystemFont(ofSize: 11)
    
    public init(cv: CV) {
        self.cv = cv
    }
    
    public func generatePDF() -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "CV Generator",
            kCGPDFContextAuthor: cv.name
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            var currentY = drawHeader()
            currentY = drawContactInfo(yPos: currentY)
            currentY = drawSummary(yPos: currentY)
            currentY = drawExperience(yPos: currentY)
            currentY = drawEducation(yPos: currentY)
            drawSkills(yPos: currentY)
        }
        
        return data
    }
    
    // MARK: - Drawing methods
    
    private func drawHeader() -> CGFloat {
        let textRect = CGRect(x: margin, y: margin, width: pageRect.width - 2 * margin, height: 50)
        cv.name.draw(in: textRect, withAttributes: [.font: headerFont])
        
        let titleRect = CGRect(x: margin, y: margin + 25, width: pageRect.width - 2 * margin, height: 30)
        cv.title.draw(in: titleRect, withAttributes: [.font: subHeaderFont])
        
        return margin + 65
    }
    
    private func drawContactInfo(yPos: CGFloat) -> CGFloat {
        let contact = cv.contactInfo
        let infoText = "\(contact.email) | \(contact.phone) | \(contact.location)"
        
        let infoRect = CGRect(x: margin, y: yPos, width: pageRect.width - 2 * margin, height: 20)
        infoText.draw(in: infoRect, withAttributes: [.font: normalFont])
        
        var linkText = ""
        if let linkedIn = contact.linkedIn {
            linkText += "LinkedIn: \(linkedIn.absoluteString)"
        }
        if let github = contact.github {
            if !linkText.isEmpty {
                linkText += " | "
            }
            linkText += "GitHub: \(github.absoluteString)"
        }
        if let website = contact.website {
            if !linkText.isEmpty {
                linkText += " | "
            }
            linkText += "Website: \(website.absoluteString)"
        }
        
        if !linkText.isEmpty {
            let linkRect = CGRect(x: margin, y: yPos + 20, width: pageRect.width - 2 * margin, height: 20)
            linkText.draw(in: linkRect, withAttributes: [.font: normalFont])
            return yPos + 50
        }
        
        return yPos + 30
    }
    
    private func drawSummary(yPos: CGFloat) -> CGFloat {
        drawSectionHeader("SUMMARY", yPos: yPos)
        
        let summaryRect = CGRect(x: margin, y: yPos + 25, width: pageRect.width - 2 * margin, height: 60)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        cv.summary.draw(in: summaryRect, withAttributes: [
            .font: normalFont,
            .paragraphStyle: paragraphStyle
        ])
        
        return yPos + 95
    }
    
    private func drawExperience(yPos: CGFloat) -> CGFloat {
        drawSectionHeader("PROFESSIONAL EXPERIENCE", yPos: yPos)
        
        var currentY = yPos + 25
        let sortedExperience = cv.experience.sorted { exp1, exp2 in
            if exp1.period.end.year > exp2.period.end.year { return true }
            if exp1.period.end.year < exp2.period.end.year { return false }
            return exp1.period.end.month > exp2.period.end.month
        }
        
        for experience in sortedExperience {
            // Draw company and role
            let companyText = "\(experience.company.name) - \(experience.role.name)"
            let companyRect = CGRect(x: margin, y: currentY, width: pageRect.width - 2 * margin - 100, height: 20)
            companyText.draw(in: companyRect, withAttributes: [.font: sectionFont])
            
            // Draw period
            let periodRect = CGRect(x: pageRect.width - margin - 100, y: currentY, width: 100, height: 20)
            experience.formattedDateRange.draw(in: periodRect, withAttributes: [
                .font: italicFont,
                .paragraphStyle: rightAlignedParagraphStyle()
            ])
            
            currentY += 25
            
            // Draw projects
            for project in experience.projects {
                currentY = drawProject(project: project, yPos: currentY)
            }
            
            currentY += 15
        }
        
        return currentY
    }
    
    private func drawProject(project: Project, yPos: CGFloat) -> CGFloat {
        // Draw project name
        let projectRect = CGRect(x: margin + 15, y: yPos, width: pageRect.width - 2 * margin - 15, height: 20)
        project.name.draw(in: projectRect, withAttributes: [.font: UIFont.boldSystemFont(ofSize: 11)])
        
        var currentY = yPos + 20
        
        // Draw project descriptions
        for description in project.descriptions {
            let bulletPoint = "• "
            let descText = bulletPoint + description
            
            let descRect = CGRect(x: margin + 30, y: currentY, width: pageRect.width - 2 * margin - 30, height: 20)
            
            // Calculate height needed for text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let descAttributes: [NSAttributedString.Key: Any] = [
                .font: normalFont,
                .paragraphStyle: paragraphStyle
            ]
            
            let textHeight = descText.boundingRect(
                with: CGSize(width: descRect.width, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: descAttributes,
                context: nil
            ).height
            
            let adjustedRect = CGRect(x: descRect.origin.x, y: descRect.origin.y, width: descRect.width, height: textHeight)
            descText.draw(in: adjustedRect, withAttributes: descAttributes)
            
            currentY += textHeight + 5
        }
        
        // Draw technologies used
        if !project.techs.isEmpty {
            let techList = project.techs.map { $0.name }.joined(separator: ", ")
            let techText = "Technologies: \(techList)"
            
            let techRect = CGRect(x: margin + 30, y: currentY, width: pageRect.width - 2 * margin - 30, height: 20)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let techAttributes: [NSAttributedString.Key: Any] = [
                .font: italicFont,
                .paragraphStyle: paragraphStyle
            ]
            
            let textHeight = techText.boundingRect(
                with: CGSize(width: techRect.width, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: techAttributes,
                context: nil
            ).height
            
            let adjustedRect = CGRect(x: techRect.origin.x, y: techRect.origin.y, width: techRect.width, height: textHeight)
            techText.draw(in: adjustedRect, withAttributes: techAttributes)
            
            currentY += textHeight + 10
        } else {
            currentY += 10
        }
        
        return currentY
    }
    
    private func drawEducation(yPos: CGFloat) -> CGFloat {
        drawSectionHeader("EDUCATION", yPos: yPos)
        
        var currentY = yPos + 25
        
        for education in cv.education {
            // Draw institution
            let institutionRect = CGRect(x: margin, y: currentY, width: pageRect.width - 2 * margin - 100, height: 20)
            education.institution.draw(in: institutionRect, withAttributes: [.font: sectionFont])
            
            // Draw period
            let periodFormatter = DateFormatter()
            periodFormatter.dateFormat = "MMM yyyy"
            
            let periodText = "\(education.period.start.month)/\(education.period.start.year) - \(education.period.end.month)/\(education.period.end.year)"
            let periodRect = CGRect(x: pageRect.width - margin - 100, y: currentY, width: 100, height: 20)
            periodText.draw(in: periodRect, withAttributes: [
                .font: italicFont,
                .paragraphStyle: rightAlignedParagraphStyle()
            ])
            
            currentY += 20
            
            // Draw degree and field
            let degreeText = "\(education.degree) in \(education.field)"
            let degreeRect = CGRect(x: margin + 15, y: currentY, width: pageRect.width - 2 * margin - 15, height: 20)
            degreeText.draw(in: degreeRect, withAttributes: [.font: normalFont])
            
            currentY += 30
        }
        
        return currentY
    }
    
    private func drawSkills(yPos: CGFloat) -> CGFloat {
        drawSectionHeader("SKILLS", yPos: yPos)
        
        var currentY = yPos + 25
        
        // Group skills if needed
        let skillsText = cv.skills.map { $0.name }.joined(separator: ", ")
        
        let skillsRect = CGRect(x: margin, y: currentY, width: pageRect.width - 2 * margin, height: 60)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let skillsAttributes: [NSAttributedString.Key: Any] = [
            .font: normalFont,
            .paragraphStyle: paragraphStyle
        ]
        
        let textHeight = skillsText.boundingRect(
            with: CGSize(width: skillsRect.width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: skillsAttributes,
            context: nil
        ).height
        
        let adjustedRect = CGRect(x: skillsRect.origin.x, y: skillsRect.origin.y, width: skillsRect.width, height: textHeight)
        skillsText.draw(in: adjustedRect, withAttributes: skillsAttributes)
        
        return currentY + textHeight + 20
    }
    
    // MARK: - Helper methods
    
    private func drawSectionHeader(_ text: String, yPos: CGFloat) {
        let rect = CGRect(x: margin, y: yPos, width: pageRect.width - 2 * margin, height: 20)
        text.draw(in: rect, withAttributes: [.font: sectionFont])
        
        // Draw underline
        let path = UIBezierPath()
        path.move(to: CGPoint(x: margin, y: yPos + 22))
        path.addLine(to: CGPoint(x: pageRect.width - margin, y: yPos + 22))
        path.lineWidth = 1.0
        UIColor.gray.setStroke()
        path.stroke()
    }
    
    private func rightAlignedParagraphStyle() -> NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.alignment = .right
        return style
    }
    
    // MARK: - Save methods
    
    public func savePDF(to fileURL: URL) -> Bool {
        guard let data = generatePDF() else { return false }
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("Error saving PDF: \(error)")
            return false
        }
    }
}

// Example usage
extension UIKitCVPDFGenerator {
    public static func generateSamplePDF(to fileURL: URL) -> Bool {
        // Create sample contact info
        let contactInfo = ContactInfo(
            email: "developer@example.com",
            phone: "+1 (555) 123-4567",
            linkedIn: URL(string: "https://linkedin.com/in/developer"),
            github: URL(string: "https://github.com/developer"),
            website: URL(string: "https://developer-portfolio.com"),
            location: "San Francisco, CA"
        )
        
        // Create sample education
        let education = [
            Education(
                institution: "University of Technology",
                degree: "Bachelor of Science",
                field: "Computer Science",
                period: Period(
                    start: .init(month: 9, year: 2009),
                    end: .init(month: 6, year: 2013)
                )
            )
        ]
        
        // Get all projects from the codebase
        let projects = Project.allCases
        
        // Create the CV
        let cv = CV.createFromProjects(
            name: "iOS Developer",
            title: "Senior iOS Engineer",
            summary: "Experienced iOS developer with over 10 years of experience building applications for iOS and macOS. " +
                    "Skilled in Swift, UIKit, SwiftUI, and a wide range of Apple technologies. " +
                    "Passionate about creating intuitive and performant user experiences.",
            contactInfo: contactInfo,
            education: education,
            projects: projects
        )
        
        // Generate PDF
        let generator = CVPDFGenerator(cv: cv)
        return generator.savePDF(to: fileURL)
    }
}
#endif
