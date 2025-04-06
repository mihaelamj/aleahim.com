import Foundation



public extension CV {
    
    static func createForMihaela() -> CV {
        let contactInfo = ContactInfo(
            email: "mihaelamj@me.com",
            phone: "+385995491157",
            linkedIn: URL(string: "https://www.linkedin.com/in/mihaelamj"),
            github: URL(string: "https://github.com/mihaelamj"),
            website: URL(string: "https://aleahim.com"),
            location: "Crna Voda 38A, 10000 Zagreb, Croatia"
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

        let allProjects = Project.allCases

        let cv = CV.createFromProjects(
            name: "Mihaela Mihaljević Jakić",
            title: "Senior iOS Architect & Developer",
            summary: """
            Experienced iOS engineer with a strong background in modular architecture, \
            OpenAPI-driven development, and multi-platform Swift apps. Known for shipping \
            polished, testable, and scalable features.
            """,
            contactInfo: contactInfo,
            education: [education],
            projects: allProjects
        )
        return cv
    }
    
    static func makeAndSavePDF(_ cv: CV) -> URL? {
        let generator = CoreGraphicsCVPDFGenerator(cv: cv)

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputURL = documentsURL.appendingPathComponent("MihaelaMihaljevicJCV.pdf")

        if generator.savePDF(to: outputURL) {
            print("PDF successfully saved to \(outputURL.path)")
        } else {
            print("Failed to save PDF")
        }
        return outputURL
    }
    
    
}
