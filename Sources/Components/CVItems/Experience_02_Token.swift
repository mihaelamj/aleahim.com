import Foundation

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
                                    "iOS app for Croatian company, for managing kindergartens"
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

