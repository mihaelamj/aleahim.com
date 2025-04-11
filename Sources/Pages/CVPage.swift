import Foundation
import Ignite
import CVBuilder

struct CVPage: StaticPage {
    var title = "CV"
    var layout: any Layout = MainLayout()

    var body: some HTML {
        Section {
            Text("Mihaela's CV")
                .font(.title1)
            
            CVIgniteRenderer(cv: CV.createForMihaela()).body
        }
    }
}
