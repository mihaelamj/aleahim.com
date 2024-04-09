//
//  Resume.swift
//
//
//  Created by Mihaela MJ on 09.04.2024..
//

import Foundation

// Define struct for personal information
struct PersonalInfo {
    let address: String
    let email: String
    let linkedin: String
    let github: String
    let skype: String
    let twitter: String
    let facetime: String
    
    static let me = PersonalInfo(
        address: "Crna voda 38 A, 10000 Zagreb (Croatia)",
        email: "mihaelamj@me.com",
        linkedin: "https://www.linkedin.com/in/mihaelamj",
        github: "https://github.com/mihaelamj",
        skype: "civeljahim",
        twitter: "civeljahim",
        facetime: "mihaelamj@me.com"
    )
}

// Define struct for education
struct Education {
    let degree: String
    let university: String
    
    static let me = Education(
        degree: "Information and Speech Science, M.Sc",
        university: "University of Zagreb Faculty of Humanities and Social Sciences"
    )
}


struct Responsibility {
    let title: String
    let url: URL?
    
    init(title: String, url: URL? = nil) {
        self.title = title
        self.url = url
    }
}

struct WorkExperience {
    let title: String
    let company: String
    let location: String
    let startDate: String
    let endDate: String
    let responsibilities: [Responsibility]
    
    static let me: [WorkExperience] = [
        WorkExperience(title: "Senior iOS Engineer",
                       company: "iOLAP",
                       location: "Rijeka (Croatia)",
                       startDate: "November 2022",
                       endDate: "Present",
                       responsibilities: [
                            Responsibility(title: "iOLAPNetworking networking framework"),
                            Responsibility(title: "GrapQL library implementation with tests"),
                            Responsibility(title: "Swift Network client code generation from OpenAPI specs",
                                           url: URL(string: "https://github.com/mihaelamj/iolapopenapiswift")),
                            Responsibility(title: "Refactoring legacy app"),
                            Responsibility(title: "Unit testing critical parts of the app")
                        ]
                      ),
        WorkExperience(
            title: "Senior iOS architect",
            company: "Cherishing Studio SP (Sole Proprietor)",
            location: "Zagreb (Croatia)",
            startDate: "September 2021",
            endDate: "October 2022",
            responsibilities: [
                Responsibility(title: "OPEN API"),
                Responsibility(title: "GraphQL"),
                Responsibility(title: "SwiftUI"),
                Responsibility(title: "UIKit")
            ]
        ),
        WorkExperience(
            title: "Senior iOS architect",
            company: "Cherishing Studio SP (Sole Proprietor)",
            location: "Zagreb (Croatia)",
            startDate: "August 2020",
            endDate: "September 2021",
            responsibilities: [
                Responsibility(title: "App architecture engineer"),
                Responsibility(title: "Designed the app from the requirements"),
                Responsibility(title: "Created functional specifications"),
                Responsibility(title: "Designed app mockups in Sketch")
            ]
        ),
        WorkExperience(
            title: "Senior iOS developer",
            company: "Cherishing Studio SP (Sole Proprietor)",
            location: "Zagreb (Croatia)",
            startDate: "August 2020",
            endDate: "2021",
            responsibilities: [
                Responsibility(title: "Refactored the whole app"),
                Responsibility(title: "Made a Swift package to generate the complete networking layer from the OpenAPI specs (JSON or YML)"),
                Responsibility(title: "Worked on the Birch Finance app (https://apps.apple.com/us/app/birch-finance/id1159533933)")
            ]
        ),
        WorkExperience(
            title: "Senior iOS developer",
            company: "Cherishing Studio SP (Sole Proprietor)",
            location: "Zagreb (Croatia)",
            startDate: "August 2019",
            endDate: "2020",
            responsibilities: [
                Responsibility(title: "Worked on the Wheels Up app (https://apps.apple.com/us/app/wheels-up/id956615077)")
            ]
        ),
        WorkExperience(
            title: "Freelance Senior iOS developer",
            company: "Zagreb (Croatia)",
            location: "",
            startDate: "May 2019",
            endDate: "July 2019",
            responsibilities: [
                Responsibility(title: "Consulting services for http://servicepal.com"),
                Responsibility(title: "Consulting services for a private client")
            ]
        ),
        WorkExperience(
            title: "Freelance Senior iOS developer for a client",
            company: "Masinerija d.o.o.",
            location: "Zagreb (Croatia)",
            startDate: "November 2018",
            endDate: "May 2019",
            responsibilities: [
                Responsibility(title: "Worked on the Birthdayrama App (https://apps.apple.com/my/app/birthdayrama/id1466195825)"),
                Responsibility(title: "Worked on the Huxly App (https://itunes.apple.com/us/app/huxly-brief-factual-news/id1317721937?ls=1&mt=8)")
            ]
        ),
        WorkExperience(
            title: "Freelance Senior iOS developer",
            company: "Token d.o.o.",
            location: "Zagreb (Croatia)",
            startDate: "June 2013",
            endDate: "September 2013",
            responsibilities: [
                Responsibility(title: "Teaching myself Vapor"),
                Responsibility(title: "Started working on my own app")
            ]
        ),
        WorkExperience(
            title: "iOS developer",
            company: "Zagreb (Croatia)",
            location: "",
            startDate: "September 2013",
            endDate: "June 2104",
            responsibilities: [
                Responsibility(title: "Worked on the Josip Broz Tito app (https://itunes.apple.com/us/app/josip-broz-tito/id803115184?mt=8)"),
                Responsibility(title: "Worked on the wogibtswas.at app (https://itunes.apple.com/de/app/wogibtswas.at-aktionen-angebote/id771962700?mt=8)"),
                Responsibility(title: "Worked on the Blade Soho app (https://itunes.apple.com/us/app/blade-soho/id895751630)"),
                Responsibility(title: "Worked on the Coachlette app")
            ]
        ),
    ]
}
