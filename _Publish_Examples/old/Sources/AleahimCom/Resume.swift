//
//  Resume.swift
//
//
//  Created by Mihaela MJ on 09.04.2024..
//

import Foundation

struct FullResume {
    let perfonalInformation = PersonalInfo.me
    let education = Education.me
    let workExperiences = WorkExperience.me
    let previousExperiences = PreviousExperience.me
    
    static let me = FullResume()
}

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
    let items: [String]?
    
    init(title: String, url: URL? = nil, items: [String]? = nil) {
        self.title = title
        self.url = url
        self.items = items
    }
}

struct PreviousExperience {
    let projects: [Project]
    let employments: [String]

    struct Project {
        let title: String
        let description: String
    }
    
    static let me = PreviousExperience(
        projects: [
            PreviousExperience.Project(
                title: "SAM Reports",
                description: "Windows desktop application for Asterisk business intelligence (BI) and reporting on multiple Asterisk machines simultaneously. Developed application, web site and payment 100."
            )
        ],
        employments: [
            "Php backend developer for 1.5 years. Worked mainly developing desktop (Windows) ERP applications.",
            "Asterisk integrator for 2 years. More information on my LinkedIn profile."
        ]
    )
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
                Responsibility(title: "Worked on the Birch Finance app",
                               url: URL(string:"https://apps.apple.com/us/app/birch-finance/id1159533933"))
            ]
        ),
        WorkExperience(
            title: "Senior iOS developer",
            company: "Cherishing Studio SP (Sole Proprietor)",
            location: "Zagreb (Croatia)",
            startDate: "August 2019",
            endDate: "2020",
            responsibilities: [
                Responsibility(title: "Worked on the Wheels Up app (https://apps.apple.com/us/app/wheels-up/id956615077)", 
                               url: URL(string: "https://apps.apple.com/us/app/wheels-up/id956615077"))
            ]
        ),
        WorkExperience(
            title: "Freelance Senior iOS developer",
            company: "Toked d.o.o. for a client via UpWork",
            location: "Zagreb (Croatia)",
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
                Responsibility(title: "Worked on the Birthdayrama App (https://apps.apple.com/my/app/birthdayrama/id1466195825)",
                               url: URL(string: "https://apps.apple.com/my/app/birthdayrama/id1466195825")),
                Responsibility(title: "Worked on the Huxly App (https://itunes.apple.com/us/app/huxly-brief-factual-news/id1317721937?ls=1&mt=8)",
                               url: URL(string: "https://itunes.apple.com/us/app/huxly-brief-factual-news/id1317721937?ls=1&mt=8"))
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
            company: "Undabot d.o.o.",
            location: "Zagreb (Croatia)",
            startDate: "September 2013",
            endDate: "June 2104",
            responsibilities: [
                Responsibility(title: "Worked on the Josip Broz Tito app",
                               url: URL(string: "https://itunes.apple.com/us/app/josip-broz-tito/id803115184?mt=8"),
                              items: [
                                "iOS (iPad) book application about the life of Josip Broz Tito.",
                                "Developed major part of the app.",
                                "Implemented custom UI in code (from design sheets), Cocoapods."
                              ]),
                Responsibility(title: "Worked on the wogibtswas.at app",
                               url: URL(string: "https://itunes.apple.com/de/app/wogibtswas.at-aktionen-angebote/id771962700?mt=8"), 
                               items: [
                                "wogibtswas.at, Austria’s biggest “what’s on offer” portal.",
                                "Participated (25% GitStats) in implementing iOS app.",
                                "Worked on implementing custom UI design in code, AFNetworking, REST services, Cocoapods"
                               ]),
                Responsibility(title: "Worked on the Blade Soho app",
                               url: URL(string: "https://itunes.apple.com/us/app/blade-soho/id895751630"), 
                               items: [
                                "Custom app for one of leading London hair salons [http://www.bladesoho.co.uk](http://www.bladesoho.co.uk)",
                                "Developed major part of the app.",
                                "Implemented custom UI in code (from design sheets), AFNetworking, REST services, Cocoapods"
                               ]),
                Responsibility(title: "Worked on the Coachlette app",
                               items: [
                    "Custom app for a client.",
                    "Developed 35% of the app."
                ])
            ]
        ),
        WorkExperience(
            title: "Senior iOS Developer (remote)",
            company: "PURCH",
            location: "New York City (USA)",
            startDate: "February 2015",
            endDate: "October 2018",
            responsibilities: [
                Responsibility(title: "Shopsavvy App",
                              url: URL(string: "https://itunes.apple.com/us/app/shop-savvy-barcode-scanner/id338828953?mt=8"), 
                               items: [
                                "Worked on parts of the app that include: barcode scanning, QR code scanning and creation, general bug fixing."
                              ]),
                Responsibility(title: "QR Code Reader and Scanner App",
                               url: URL(string: "https://itunes.apple.com/us/app/qr-code-reader-and-scanner/id388175979?mt=8"), 
                               items: [
                                "Worked on parts of the app that include: QR code scanning and creation, adding new features."
                               ]),
                Responsibility(title: "Consumr App",
                               url: URL(string: "https://itunes.apple.com/us/app/consumr-reviews-product-barcode/id519874080"), 
                               items: [
                                "Adapting existing client application for iOS 8, for a client through ODesk.",
                                "Implemented detailed Gap analysis for the application including iOS frontend and REST API backend differences.",
                                "Implemented custom UI design code (from design sheets).",
                                "REST API implementation.",
                                "Used Core Animation, Auto Layout, AFNetworking, Push notifications.",
                                "Additional tools used: PaintCode, Sketch, Scrivener, HockeyApp.",
                                "Daily SCRUM Skype meetings with client's team."
                               ])
            ]
        ),
        WorkExperience(
            title: "Freelance iOS developer",
            company: "Toked d.o.o. for various clients",
            location: "Zagreb (Croatia)",
            startDate: "May 2014",
            endDate: "January 2015",
            responsibilities: [
                Responsibility(title: "Christian Resources App (https://itunes.apple.com/us/app/bible-study-tools-christian/id600610494?mt=8)",
                               url: URL(string: "https://itunes.apple.com/us/app/bible-study-tools-christian/id600610494?mt=8"),
                              items: [
                                "Universal iOS app (iPhone and iPad), for a client through ODesk",
                                "Developed the application(100%)",
                                "Created design in Sketch and implemented it in the application, dynamic UI for iPhone 4, iPhone 5, iPhone 6, iPhone 6 Plus and iPads.",
                                "Used Core Animation, Auto Layout, AFNetworking, remote audio streaming.",
                                "Client changed parts of the UI afterwards."
                              ]),
                Responsibility(title: "Whatt social network app (https://itunes.apple.com/us/app/whatt/id739776660?ls=1&mt=8)",
                               url: URL(string: "https://itunes.apple.com/us/app/whatt/id739776660?ls=1&mt=8"),
                              items: [
                                "iOS app for social network",
                                "Added features to the app: custom UITextView with links and tagging functionality, custom UI in code"
                              ]),
                Responsibility(title: "Kindergarten - iPhone app (cancelled)",
                              items: [
                                "iOS app for Croatian company, for managing kindergartens.",
                                "Developed 90% of the app.",
                                "Designed REST APIs and implemented it in the app.",
                                "Implemented custom UI design code (from design sheets).",
                                "Used Core Animation, Auto Layout, Cocoapods."
                              ])
            ]
        ),
        WorkExperience(
            title: "iOS developer",
            company: "Toked d.o.o.",
            location: "Zagreb (Croatia)",
            startDate: "September 2013",
            endDate: "June 2104",
            responsibilities: [
                Responsibility(title: "Worked on the HRTecaj app (https://itunes.apple.com/us/app/hrtecaj/id672455645)",
                               url: URL(string: "https://itunes.apple.com/us/app/hrtecaj/id672455645"),
                              items: [
                                "Universal iOS application (iPhone and iPad) for showing exchange rates of main Croatian banks _(100%)",
                                "Fetching and parsing exchange rates from the web.",
                                "Storyboard GUI for iPhone and iPad"
                              ])
            ]
        )
    ]
}

