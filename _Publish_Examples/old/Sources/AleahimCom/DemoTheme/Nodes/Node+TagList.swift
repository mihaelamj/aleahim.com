

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func tagList(for tags: [Tag], on site: AleahimCom) -> Node {
        return .div(.class("post-tags"), .forEach(tags) { tag in
            .a(
                .class("post-category post-category-\(tag.string.lowercased())"),
                .href(site.path(for: tag)),
                .text(tag.string)
            )
        })
    }
    
    static func tagList(for item: Item<AleahimCom>, on site: AleahimCom) -> Node {
        return .tagList(for: item.tags, on: site)
        
    }
    
    static func tagList(for page: TagListPage, on site: AleahimCom) -> Node {
        return .tagList(for: Array(page.tags), on: site)
    }
}
