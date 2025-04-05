import Foundation
import Ignite

struct NavBar: HTML {
    let name: String
    
    private var logo: any InlineElement {
        Text(name)
            .fontWeight(.bold)
            .margin(.none)
            .font(.title4)
            .foregroundStyle(.white) as! (any InlineElement)
    }
    
    var body: some HTML {
        NavigationBar(logo: logo) {
            for item in Categories.allCases {
                Link(item.rawValue, target: item.page)

            }
        }
        .navigationItemAlignment(.trailing)
        .background(.firebrick)
        .position(.fixedTop)
    }
}
