import Foundation
import CVBuilder

public extension CV {
    static func createForMihaela() -> CV {
        let contactInfo = ContactInfo(
            email: "mihaelamj@me.com",
            phone: "+385995491157",
            linkedIn: URL(string: "https://www.linkedin.com/in/mihaelamj"),
            github: URL(string: "https://github.com/mihaelamj"),
            website: URL(string: "https://aleahim.com"),
            location: "Zagreb, Croatia"
        )

        let education = Education(
            institution: "University of Zagreb, Faculty of Humanities and Social Sciences",
            degree: "M.Sc.",
            field: "Information and Speech Science",
            period: Period(
                start: .init(month: 10, year: 1990),
                end: .init(month: 6, year: 1996)
            )
        )
        let projects = createMihaelasProjects()

        return CV.create(
            name: "Mihaela Mihaljević Jakić",
            title: "Senior iOS Architect | Swift Server & OpenAPI | AI Tooling",
            summary: """
            Experienced iOS engineer with a deep commitment to modular architecture and elegant code. \
            I specialize in OpenAPI-driven development and AI-augmented tooling, building robust, \
            multi-platform Swift applications that scale gracefully. From MCP servers that bring Apple \
            documentation to AI assistants, to native AI-powered apps, I bridge the gap between Apple \
            platform engineering and modern AI workflows. My work is defined by clean structure, extreme \
            attention to testability, and the kind of modularization that makes features easy to extend, \
            reason about, and maintain. I take pride in shipping polished, production-grade software that \
            balances design clarity with engineering precision.
            """,
            contactInfo: contactInfo,
            education: [education],
            projects: projects
        )
    }
}
