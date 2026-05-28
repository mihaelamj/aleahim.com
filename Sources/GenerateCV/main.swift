import Foundation
import CVBuilder

// MARK: - Configuration

let twitterURL = "https://x.com/diyamantina"
let pdfPath = "/assets/Mihaela_Mihaljevic_Jakic_CV.pdf"

let companyURLs: [String: String] = [
    "Code Weaver": "https://codeweaver.info",
    "Maurer Electronics": "https://www.maurer-electronics.de",
]

struct Conference {
    let name: String
    let date: String
    let role: String
    let title: String
    let location: String
    let website: (label: String, url: String)
    let recordingURL: String?
}

let conferences = [
    Conference(
        name: "iOSKonf26",
        date: "May 2026",
        role: "Speaker",
        title: "Teaching AI to Read Apple Docs: Building Cupertino, an MCP Server in Swift",
        location: "iOSKonf26, Skopje, North Macedonia",
        website: ("iOSKonf", "https://ioskonf.mk"),
        recordingURL: nil
    ),
    Conference(
        name: "NSSpain XIII",
        date: "Sep 2025",
        role: "Speaker",
        title: "API-Driven Development Refactored: Scaling Server and Client Code in Highly Modular Architectures",
        location: "NSSpain XIII, Logroño, Spain",
        website: ("NSSpain", "https://nsspain.com"),
        recordingURL: "https://www.youtube.com/watch?v=RyRKItIIADc&list=PLztE34GS_piKKQ6y1dkkuhW76jLBHm3NV&index=17"
    ),
]

struct OpenSourceProject {
    let name: String
    let description: String
    let url: String
    let techs: String
}

let openSourceProjects = [
    OpenSourceProject(
        name: "Cupertino",
        description: "Local Apple documentation crawler and MCP server in Swift, giving AI coding assistants offline, accurate Apple developer docs.",
        url: "https://github.com/mihaelamj/cupertino",
        techs: "Swift, MCP, AI Tooling, Swift Package Manager"
    ),
    OpenSourceProject(
        name: "iRelay",
        description: "Apple-native personal AI assistant in pure Swift, cross-platform macOS and iOS.",
        url: "https://github.com/mihaelamj/iRelay",
        techs: "Swift, SwiftUI, AppKit, AI"
    ),
    OpenSourceProject(
        name: "OpenAPIDoctor",
        description: "Typed validator and auto-repair CLI for OpenAPI specifications.",
        url: "https://github.com/mihaelamj/OpenAPIDoctor",
        techs: "Swift, OpenAPI, CLI"
    ),
    OpenSourceProject(
        name: "ExtremePackaging",
        description: "Modular Swift package architecture: single-responsibility targets with unidirectional dependencies, with a full OpenAPI integration example.",
        url: "https://github.com/mihaelamj/ExtremePackaging",
        techs: "Swift, Swift Package Manager, OpenAPI"
    ),
    OpenSourceProject(
        name: "OpenAPILoggingMiddleware",
        description: "Structured request logging middleware for OpenAPI-driven Swift servers.",
        url: "https://github.com/mihaelamj/OpenAPILoggingMiddleware",
        techs: "Swift, OpenAPI, Swift Server"
    ),
    OpenSourceProject(
        name: "CVBuilder",
        description: "Type-safe Swift package that models and renders a CV as data. It generates this CV.",
        url: "https://github.com/mihaelamj/cvbuilder",
        techs: "Swift, Swift Package Manager"
    ),
]

// MARK: - Render

func renderWebsiteCV(_ cv: CV) -> String {
    var out = ""

    // Toucan frontmatter
    out += "---\n"
    out += "slug: cv\n"
    out += "title: Curriculum Vitae\n"
    out += "description: \(cv.name) - \(cv.title)\n"
    out += "---\n\n"

    // Header
    out += "# \(cv.name)\n"
    out += "## \(cv.title)\n\n"

    // Summary
    out += "\(cv.summary)\n\n"

    // Contact
    out += "**Contact:**\n"
    out += "- Email: \(cv.contactInfo.email)\n"
    out += "- Phone: \(cv.contactInfo.phone)\n"
    out += "- Location: \(cv.contactInfo.location)\n"
    if let linkedIn = cv.contactInfo.linkedIn {
        out += "- [LinkedIn](\(linkedIn.absoluteString))\n"
    }
    if let github = cv.contactInfo.github {
        out += "- [GitHub](\(github.absoluteString))\n"
    }
    out += "- [X/Twitter](\(twitterURL))\n"
    if let website = cv.contactInfo.website {
        out += "- [Blog](\(website.absoluteString))\n"
    }
    out += "- [Download CV (PDF)](\(pdfPath))\n"
    out += "\n"

    // Education
    out += "**Education:**\n"
    for edu in cv.education {
        out += "- \(edu.degree) in \(edu.field)\n"
        out += "- \(edu.institution)\n"
    }
    out += "\n"

    // Experience
    //
    // Length controls. The full work history stays in the data; the renderer
    // shows a recruiter-friendly subset. To go from a ~2-page CV to ~1 page,
    // lower these two numbers (e.g. recentCompanyCount = 3, maxBulletsPerProject = 2).
    let recentCompanyCount = 4      // most-recent companies shown in full
    let maxBulletsPerProject = 4    // cap on description bullets per project

    // Companies where the role is ongoing, rendered as "... - Present".
    // CVBuilder's Period requires a concrete end date, so this is a display override.
    let currentRoles: Set<String> = ["Maurer Electronics"]

    // Independent open-source work (Cupertino, iRelay) gets its own OPEN SOURCE
    // section below, so exclude it from the employment timeline here.
    let sortedExperience = cv.experience
        .filter { $0.company.name != "Independent" }
        .sorted(by: { $0.period.end > $1.period.end })
    let recentExperience = sortedExperience.prefix(recentCompanyCount)
    let earlierExperience = sortedExperience.dropFirst(recentCompanyCount)

    out += "## EXPERIENCE\n\n"
    for exp in recentExperience {
        let companyName = exp.company.name
        let dateRange = currentRoles.contains(companyName)
            ? (exp.formattedDateRange.components(separatedBy: " - ").first ?? exp.formattedDateRange) + " - Present"
            : exp.formattedDateRange
        if let url = companyURLs[companyName] {
            out += "### [\(companyName)](\(url)) (\(dateRange)), \(exp.role.title)\n\n"
        } else {
            out += "### \(companyName) (\(dateRange)), \(exp.role.title)\n\n"
        }
        for projectExp in exp.projects.sorted(by: { $0.period.start > $1.period.start }) {
            let project = projectExp.project
            out += "#### \(project.name)\n"
            for desc in project.descriptions.prefix(maxBulletsPerProject) {
                out += "- \(desc)\n"
            }
            if let urls = project.urls, !urls.isEmpty {
                for url in urls {
                    out += "- [\(url.absoluteString)](\(url.absoluteString))\n"
                }
            }
            out += "\n"
            let techLine = project.techs.map(\.name).joined(separator: ", ")
            out += "**Technologies:** \(techLine)\n\n"
        }
    }

    // Earlier roles, condensed to one line each (no project detail).
    if !earlierExperience.isEmpty {
        out += "## EARLIER EXPERIENCE\n\n"
        for exp in earlierExperience {
            out += "- **\(exp.company.name)** (\(exp.formattedDateRange)), \(exp.role.title)\n"
        }
        out += "\n"
    }

    // Open Source
    out += "## OPEN SOURCE\n\n"
    for osp in openSourceProjects {
        out += "### [\(osp.name)](\(osp.url))\n"
        out += "- \(osp.description)\n\n"
        out += "**Technologies:** \(osp.techs)\n\n"
    }

    // Speaking
    out += "## SPEAKING\n\n"
    for conf in conferences {
        out += "### \(conf.name) (\(conf.date)), \(conf.role)\n"
        out += "- \"\(conf.title)\"\n"
        out += "- \(conf.location)\n"
        out += "- [\(conf.website.label)](\(conf.website.url))\n"
        if let recording = conf.recordingURL {
            out += "- [Talk recording](\(recording))\n"
        }
        out += "\n"
    }

    // Skills
    out += "## SKILLS\n\n"
    let skillLine = cv.skills.map(\.name).joined(separator: " | ")
    out += "\(skillLine)\n\n"

    // Attribution
    out += "---\n\n"
    out += "*Created with [CVBuilder](https://github.com/mihaelamj/cvbuilder)*\n"

    return out
}

// MARK: - Generate

let cv = CV.createForMihaela()
let markdown = renderWebsiteCV(cv)

let outputPath = "contents/cv/index.md"
let fileURL = URL(fileURLWithPath: outputPath)

do {
    try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
    print("CV written to \(fileURL.path)")
} catch {
    print("Failed to write CV: \(error.localizedDescription)")
    exit(1)
}
