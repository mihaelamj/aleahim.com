import Foundation
import Ignite

enum Categories: String, CaseIterable {
    case blog = "Home"
    case about = "About"
    case cv = "CV"
    case contact = "Contact"
    
    @MainActor
    var page: any StaticPage {
        switch self {
        case .blog: return Home()
        case .about: return About()
        case .cv: return CV()
        case .contact: return Contact()
        }
    }
}

public struct CategoryItems: HTML {
    
    public var body: some HTML {
        HStack(spacing: 20) {
            ForEach(Categories.allCases) { item in
                Link(target: item.page) {
                    Text("\(item.rawValue)")
                        .margin(.none)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}
