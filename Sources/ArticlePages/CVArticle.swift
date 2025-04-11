import Foundation
import Ignite
import CVBuilder
import CVBuilderIgnite

struct CVArticle: ArticlePage {
    var body: some HTML {
        let cv = CV.createForMihaela()
        IgniteRenderer(cv: cv).body
    }
} 
