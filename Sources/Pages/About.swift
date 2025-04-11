import Foundation
import Ignite

struct About: StaticPage {
    var title = "About"
    var layout: any Layout = MainLayout()

    var body: some HTML {
        Text("About Me")
            .font(.title1)
    }
}
