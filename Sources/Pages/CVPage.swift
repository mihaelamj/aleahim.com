import Foundation
import Ignite

struct CVPage: StaticPage {
    var title = "CV"
    var layout: any Layout = MainLayout()

    var body: some HTML {
        Text("Mihaela's CV")
            .font(.title1)
    }
}
