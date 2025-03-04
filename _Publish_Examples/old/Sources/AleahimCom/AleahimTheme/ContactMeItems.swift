//
//  ContactMeItems.swift
//
//
//  Created by Mihaela MJ on 09.04.2024..
//

import Plot

extension Node where Context == HTML.BodyContext {
    static func contactList(_ contacts: [ContactMe]) -> Node {
        .ul(
            .forEach(contacts) { contact in
                .li(
                    .a(
                        .href(contact.url),
                        .text(contact.title),
                        .class("icon \(contact.icon)") 
                    )
                )
            }
        )
    }
}

import Publish

struct ContactMeItemList<Site: Website>: Component {
    var contacts: [ContactMe]
    var site: Site
    
    var body: Component {
        List(contacts) { contact in
            Link(contact.title, url: contact.url)
        }
        .class("item-list")
    }
}



