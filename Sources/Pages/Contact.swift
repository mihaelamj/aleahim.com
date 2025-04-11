import Foundation
import Ignite

struct Contact: StaticPage {
    var title = "Contact"
    var layout: any Layout = MainLayout()

    var body: some HTML {
        Text("Contact Me")
            .font(.title1)
    }
}
