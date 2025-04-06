import Foundation
import Ignite
import mycv

enum Page: String, CaseIterable {
    case blog = "Home"
    case about = "About"
    case cv = "CV"
    case contact = "Contact"
    
    @MainActor
    var page: any StaticPage {
        switch self {
        case .blog: return Home()
        case .about: return About()
        case .cv: return CVPage()
        case .contact: return Contact()
        }
    }
    
    @MainActor
    static var all: [any StaticPage] {
        Self.allCases.map { $0.page }
    }
}

public protocol StaticPageWithCV: StaticPage {
    var cv: CV { get }
}

public extension StaticPageWithCV {
   var cv: CV {
        CV.createForMihaela()
    }
}

public struct BlogPage: StaticPageWithCV {
    public var title = "MIhaela's Blog"

    public var body: some HTML {
        Text("Hello Aleahim")
            .font(.title1)
    }
    
    func test() {
        let email = cv.contactInfo.email
    }
}
