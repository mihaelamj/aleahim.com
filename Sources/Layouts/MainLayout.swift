import Foundation
import Ignite

struct MainLayout: Layout {
    var body: some HTML {
        Body {
            NavBar(name: "")
                .padding(.bottom, 80)
            
            content
            
            Section {
                SocialFooter()
                IgniteFooter()
                    .margin(.bottom, 80)
            }
        }
    }
}
