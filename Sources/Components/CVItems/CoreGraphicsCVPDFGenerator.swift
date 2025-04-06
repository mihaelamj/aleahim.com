import Foundation
import CoreGraphics

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public class CoreGraphicsCVPDFGenerator {
    private let cv: CV
    private let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter size
    private let margin: CGFloat = 50
    
    // Cross-platform font handling
    #if os(macOS)
    private let defaultFont = NSFont.systemFont(ofSize: 11)
    private let headerFont = NSFont.boldSystemFont(ofSize: 16)
    private let subHeaderFont = NSFont.boldSystemFont(ofSize: 14)
    private let sectionFont = NSFont.boldSystemFont(ofSize: 12)
    private let normalFont = NSFont.systemFont(ofSize: 11)
    private let italicFont = NSFont(name: "Helvetica-Oblique", size: 11) ?? NSFont.systemFont(ofSize: 11)
    #else
    private let defaultFont = UIFont.systemFont(ofSize: 11)
    private let headerFont = UIFont.boldSystemFont(ofSize: 16)
    private let subHeaderFont = UIFont.boldSystemFont(ofSize: 14)
    private let sectionFont = UIFont.boldSystemFont(ofSize: 12)
    private let normalFont = UIFont.systemFont(ofSize: 11)
    private let italicFont = UIFont.italicSystemFont(ofSize: 11)
    #endif
    
    public init(cv: CV) {
        self.cv = cv
    }
    
    public func generatePDF() -> Data? {
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData) else { return nil }
        
        let pdfMetaData: [CFString: CFString] = [
            kCGPDFContextCreator: "CV Generator" as CFString,
            kCGPDFContextAuthor: cv.name as CFString
        ]
        let options = pdfMetaData as CFDictionary
        
        // Pass pointer to pageRect
        var rect = pageRect
        guard let context = CGContext(consumer: consumer, mediaBox: &rect, options) else { return nil }
        
        // Use empty dictionary for page info instead of nil
        context.beginPDFPage([:] as CFDictionary)
        drawContent(context: context)
        context.endPDFPage()
        context.closePDF()
        
        return data as Data
    }
    
    private func drawContent(context: CGContext) {
        context.saveGState()
        // Flip coordinate system to match UIKit's top-to-bottom
        context.translateBy(x: 0, y: pageRect.height)
        context.scaleBy(x: 1, y: -1)
        
        var currentY = margin
        currentY = drawHeader(context: context, yPos: currentY)
        currentY = drawContactInfo(context: context, yPos: currentY)
        currentY = drawSummary(context: context, yPos: currentY)
        currentY = drawExperience(context: context, yPos: currentY)
        currentY = drawEducation(context: context, yPos: currentY)
        drawSkills(context: context, yPos: currentY)
        
        context.restoreGState()
    }
    
    // MARK: - Drawing methods
    
    private func drawHeader(context: CGContext, yPos: CGFloat) -> CGFloat {
        let textRect = CGRect(x: margin, y: yPos, width: pageRect.width - 2 * margin, height: 50)
        drawText(cv.name, in: textRect, font: headerFont, context: context)
        
        let titleRect = CGRect(x: margin, y: yPos + 25, width: pageRect.width - 2 * margin, height: 30)
        drawText(cv.title, in: titleRect, font: subHeaderFont, context: context)
        
        return yPos + 65
    }
    
    private func drawContactInfo(context: CGContext, yPos: CGFloat) -> CGFloat {
        let contact = cv.contactInfo
        let infoText = "\(contact.email) | \(contact.phone) | \(contact.location)"
        
        let infoRect = CGRect(x: margin, y: yPos, width: pageRect.width - 2 * margin, height: 20)
        drawText(infoText, in: infoRect, font: normalFont, context: context)
        
        var linkText = ""
        if let linkedIn = contact.linkedIn {
            linkText += "LinkedIn: \(linkedIn.absoluteString)"
        }
        if let github = contact.github {
            if !linkText.isEmpty { linkText += " | " }
            linkText += "GitHub: \(github.absoluteString)"
        }
        if let website = contact.website {
            if !linkText.isEmpty { linkText += " | " }
            linkText += "Website: \(website.absoluteString)"
        }
        
        if !linkText.isEmpty {
            let linkRect = CGRect(x: margin, y: yPos + 20, width: pageRect.width - 2 * margin, height: 20)
            drawText(linkText, in: linkRect, font: normalFont, context: context)
            return yPos + 50
        }
        
        return yPos + 30
    }
    
    private func drawSummary(context: CGContext, yPos: CGFloat) -> CGFloat {
        drawSectionHeader("SUMMARY", yPos: yPos, context: context)
        
        let summaryRect = CGRect(x: margin, y: yPos + 25, width: pageRect.width - 2 * margin, height: 60)
        drawText(cv.summary, in: summaryRect, font: normalFont, lineSpacing: 5, context: context)
        
        return yPos + 95
    }
    
    private func drawExperience(context: CGContext, yPos: CGFloat) -> CGFloat {
        drawSectionHeader("PROFESSIONAL EXPERIENCE", yPos: yPos, context: context)
        
        var currentY = yPos + 25
        let sortedExperience = cv.experience.sorted { exp1, exp2 in
            exp1.period.end > exp2.period.end  // This will now work
        }
        
        for experience in sortedExperience {
            let companyText = "\(experience.company.name) - \(experience.role.name)"
            let companyRect = CGRect(x: margin, y: currentY, width: pageRect.width - 2 * margin - 100, height: 20)
            drawText(companyText, in: companyRect, font: sectionFont, context: context)
            
            let periodRect = CGRect(x: pageRect.width - margin - 100, y: currentY, width: 100, height: 20)
            drawText(experience.formattedDateRange, in: periodRect, font: italicFont, alignment: .right, context: context)
            
            currentY += 25
            
            for project in experience.projects {
                currentY = drawProject(project: project, yPos: currentY, context: context)
            }
            currentY += 15
        }
        
        return currentY
    }
    
    private func drawProject(project: Project, yPos: CGFloat, context: CGContext) -> CGFloat {
        let projectRect = CGRect(x: margin + 15, y: yPos, width: pageRect.width - 2 * margin - 15, height: 20)
        #if os(macOS)
        let boldFont = NSFont.boldSystemFont(ofSize: 11)
        #else
        let boldFont = UIFont.boldSystemFont(ofSize: 11)
        #endif
        drawText(project.name, in: projectRect, font: boldFont, context: context)
        
        var currentY = yPos + 20
        
        for description in project.descriptions {
            let descText = "• " + description
            let descRect = CGRect(x: margin + 30, y: currentY, width: pageRect.width - 2 * margin - 30, height: 0)
            currentY += drawText(descText, in: descRect, font: normalFont, context: context) + 5
        }
        
        if !project.techs.isEmpty {
            let techList = project.techs.map { $0.name }.joined(separator: ", ")
            let techText = "Technologies: \(techList)"
            let techRect = CGRect(x: margin + 30, y: currentY, width: pageRect.width - 2 * margin - 30, height: 0)
            currentY += drawText(techText, in: techRect, font: italicFont, context: context) + 10
        } else {
            currentY += 10
        }
        
        return currentY
    }
    
    private func drawEducation(context: CGContext, yPos: CGFloat) -> CGFloat {
        drawSectionHeader("EDUCATION", yPos: yPos, context: context)
        
        var currentY = yPos + 25
        
        for education in cv.education {
            let institutionRect = CGRect(x: margin, y: currentY, width: pageRect.width - 2 * margin - 100, height: 20)
            drawText(education.institution, in: institutionRect, font: sectionFont, context: context)
            
            let periodText = "\(education.period.start.month)/\(education.period.start.year) - \(education.period.end.month)/\(education.period.end.year)"
            let periodRect = CGRect(x: pageRect.width - margin - 100, y: currentY, width: 100, height: 20)
            drawText(periodText, in: periodRect, font: italicFont, alignment: .right, context: context)
            
            currentY += 20
            
            let degreeText = "\(education.degree) in \(education.field)"
            let degreeRect = CGRect(x: margin + 15, y: currentY, width: pageRect.width - 2 * margin - 15, height: 20)
            drawText(degreeText, in: degreeRect, font: normalFont, context: context)
            
            currentY += 30
        }
        
        return currentY
    }
    
    private func drawSkills(context: CGContext, yPos: CGFloat) {
        drawSectionHeader("SKILLS", yPos: yPos, context: context)
        
        let skillsText = cv.skills.map { $0.name }.joined(separator: ", ")
        let skillsRect = CGRect(x: self.margin, y: yPos + 25, width: pageRect.width - 2 * self.margin, height: 60)
        drawText(skillsText, in: skillsRect, font: normalFont, lineSpacing: 5, context: context)
    }
    
    // MARK: - Helper methods
    
    private func drawSectionHeader(_ text: String, yPos: CGFloat, context: CGContext) {
        let rect = CGRect(x: margin, y: yPos, width: pageRect.width - 2 * margin, height: 20)
        drawText(text, in: rect, font: sectionFont, context: context)
        
        context.saveGState()
        context.setLineWidth(1.0)
        context.setStrokeColor(CGColor(gray: 0.5, alpha: 1.0))
        context.move(to: CGPoint(x: margin, y: yPos + 22))
        context.addLine(to: CGPoint(x: pageRect.width - margin, y: yPos + 22))
        context.strokePath()
        context.restoreGState()
    }
    
    @discardableResult
    private func drawText(_ text: String, in rect: CGRect, font: Any, alignment: NSTextAlignment = .left, lineSpacing: CGFloat = 0, context: CGContext) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        
        #if os(macOS)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as! NSFont,
            .paragraphStyle: paragraphStyle
        ]
        #else
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font as! UIFont,
            .paragraphStyle: paragraphStyle
        ]
        #endif
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textHeight = attributedString.boundingRect(with: CGSize(width: rect.width, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin], context: nil).height
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let framePath = CGPath(rect: rect, transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), framePath, nil)
        CTFrameDraw(frame, context)
        
        return textHeight
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
