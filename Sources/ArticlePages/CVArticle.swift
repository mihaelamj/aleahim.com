import Foundation
import Ignite
import CVBuilder

struct CVArticle: ArticlePage {
    var body: some HTML {
        let cv = CV.createForMihaela()
        CVIgniteRenderer(cv: cv).body
    }
} 