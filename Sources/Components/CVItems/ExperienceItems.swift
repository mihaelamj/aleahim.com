import Foundation

extension Experience {
    static let undabotItems: [Experience] = {
        var items: [Experience] = []
        
        let titoItem = Experience(project: .tito,
                                  company: .undabot,
                                  period: .init(start: .init(month: 9, year: 2013),
                                                end: .init(month: 11, year: 2013)),
                                  role: .junior,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .coretext,
                                    .coregraphics,
                                    .coreanimation,
                                    .cocapods
                                  ],
                                  descriptions: [
                                    "iOS (iPad) book application about the life of Josip Broz Tito",
                                    "Objective-C, Cocoapods",
                                    "Implemented custom UI in code (from design sheets)",
                                    "CoreText custom page layouts"
                                  ])
        items.append(titoItem)
        
        let wogiItem = Experience(project: .wogibtswas,
                                  company: .undabot,
                                  period: .init(start: .init(month: 11, year: 2013),
                                                end: .init(month: 1, year: 2014)),
                                  role: .junior,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .afnet,
                                    .autolayout,
                                    .rest
                                  ],
                                   urls: [
                                    URL(string:"https://itunes.apple.com/de/app/wogibtswas.at-aktionen-angebote/id771962700")!,
                                    URL(string: "https://www.wogibtswas.at")!
                                   ],
                                  descriptions: [
                                    "wogibtswas.at, Austria’s biggest \"what’s on offer\" portal.",
                                    "Objective-C, AFNetworking, REST services, Cocoapods",
                                    "Custom UI design in code"
                                  ])
        items.append(wogiItem)
        
        let bladeItem = Experience(project: .bladesoho,
                                  company: .undabot,
                                  period: .init(start: .init(month: 1, year: 2014),
                                                end: .init(month: 5, year: 2014)),
                                  role: .junior,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .afnet,
                                    .autolayout,
                                    .rest
                                  ],
                                   urls: [
                                    URL(string: "https://www.bladesoho.co.uk")!
                                   ],
                                  descriptions: [
                                    "Custom app for one of leading London hair salons",
                                    "Objective-C, AFNetworking, REST services, Cocoapods",
                                    "Implemented custom UI in code (from design sheets)"
                                  ])
        items.append(bladeItem)
        
        let coachItem = Experience(project: .coachlette,
                                  company: .undabot,
                                  period: .init(start: .init(month: 5, year: 2014),
                                                end: .init(month: 6, year: 2014)),
                                  role: .junior,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .afnet,
                                    .autolayout,
                                    .rest
                                  ],
                                  descriptions: [
                                    "Custom app for a personal trainers and coaches",
                                    "Objective-C, AFNetworking, REST services, Cocoapods",
                                    "Implemented custom UI in code"
                                  ])
        items.append(coachItem)
        
        return items
    }()
}

extension Experience {
    static let tokenItems: [Experience] = {
        var items: [Experience] = []
        
        let kindertem = Experience(project: .kindergarten,
                                  company: .token,
                                  period: .init(start: .init(month: 6, year: 2014),
                                                end: .init(month: 7, year: 2014)),
                                  role: .mid,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .coretext,
                                    .coregraphics,
                                    .coreanimation,
                                    .cocapods
                                  ],
                                  descriptions: [
                                  ])
        items.append(kindertem)
        
        let whatttem = Experience(project: .whatt,
                                  company: .token,
                                  period: .init(start: .init(month: 7, year: 2014),
                                                end: .init(month: 10, year: 2014)),
                                  role: .mid,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .coretext,
                                    .coregraphics,
                                    .coreanimation,
                                    .cocapods
                                  ],
                                  descriptions: [
                                  ])
        items.append(whatttem)
        
        let chrisitem = Experience(project: .christresources,
                                  company: .token,
                                  period: .init(start: .init(month: 10, year: 2014),
                                                end: .init(month: 2, year: 2015)),
                                  role: .mid,
                                  techs: [
                                    .objc,
                                    .uikit,
                                    .uiincode,
                                    .coretext,
                                    .coregraphics,
                                    .coreanimation,
                                    .cocapods
                                  ],
                                  descriptions: [
                                  ])
        items.append(chrisitem)
        
        return items
    }()
}

