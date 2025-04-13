import Foundation
import Ignite

struct BlogCard: HTML {

    var article: Article

    var body: some HTML {
        ZStack(alignment: .bottom) {
            if let image = article.image {
                Image(image)
                    .imageFit(.cover, anchor: .topTrailing)
            }
            VStack(spacing: 6) {
                Text(article.date.formatted(date: .abbreviated, time: .omitted))
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Text(article.title)
                    .font(.title4)
                    .fontWeight(Font.Weight.bold)
                if let subtitle = article.subtitle {
                    Text(subtitle)
                }
            }
            .lineSpacing(1.2)
            .padding(.horizontal, .medium)
            .padding(.vertical, .medium)
            .background(.regularMaterial)
            .frame(maxWidth: .percent(30%))
        }
        .clipped()
        .cornerRadius(15)
    }
}

struct Home: StaticPage {
    var title = "Mihaela's Blog"
    var layout: any Layout = MainLayout()
    @Environment(\.articles) private var articles

    var body: some HTML {
        Text("Mihaela's Apple Dev Blog")
            .font(.title1)
        
        List {
            ForEach(articles.all) { article in
                Link(target: article) {
                    BlogCard(article: article)
                }
            }
        }
    }
}
