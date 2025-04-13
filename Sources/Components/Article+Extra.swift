import Foundation
import Ignite

extension ArticleLoader {
    public var sortedByDate: [Article] {
        all.sorted { $0.date > $1.date }
    }
}

struct BlogCard: HTML {

    var article: Article

    var body: some HTML {
        ZStack(alignment: .bottom) {
            if let image = article.image {
                Image(image)
                    .imageFit(.fit, anchor: .topTrailing)
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
