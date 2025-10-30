import Foundation
import Ignite

struct Consulting: StaticPage {
    var title = "Consulting"
    var layout: any Layout = MainLayout()

    var body: some HTML {
        Section {
            Text("Build Your Server and Client From One OpenAPI Spec")
                .font(.title1)
                .margin(.bottom, .medium)

            Text("I help teams ship a fully integrated OpenAPI workflow—designing the spec, generating a Vapor server, and producing Swift clients that share the same contracts. The workflow comes straight from the ExtremePackaging + OpenAPI reference implementation, adapted to fit your stack.")
                .margin(.bottom, .large)

            Section {
                Text("What We Assemble Together")
                    .font(.title2)
                    .margin(.bottom, .medium)

                List {
                    ListItem {
                        Text("OpenAPI schema design and modular folder layout powered by YamlMerger.")
                    }
                    ListItem {
                        Text("Automated Swift OpenAPI Generator pipeline with shared models, clients, and server stubs.")
                    }
                    ListItem {
                        Text("Vapor-based API server that mirrors your spec with production-style logging and validation.")
                    }
                    ListItem {
                        Text("Concurrency-safe Swift client featuring logging, auth, and request correction middleware.")
                    }
                    ListItem {
                        Text("Testing strategy covering local server and remote environments so regressions get caught early.")
                    }
                }
            }
            .margin(.bottom, .xLarge)

            Section {
                Text("Engagement Options")
                    .font(.title2)
                    .margin(.bottom, .medium)

                List {
                    ListItem {
                        VStack(alignment: .leading) {
                            Text("Architecture Hour • starting at €80/hour")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Targeted pairing on spec design, generator setup, or module layout decisions.")
                            Text("Need a quick-turn review? Priority sessions land at €100–€130/hour.")
                                .foregroundStyle(.secondary)
                        }
                        .margin(.bottom, .medium)
                    }
                    ListItem {
                        VStack(alignment: .leading) {
                            Text("Build Day • €640/day")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Hands-on implementation sprint to wire the OpenAPI toolchain into your codebase.")
                        }
                        .margin(.bottom, .medium)
                    }
                    ListItem {
                        VStack(alignment: .leading) {
                            Text("Delivery Week • €2,800/week")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("End-to-end engagement that ships the server, client, middleware, and tests with your team.")
                        }
                    }
                }
            }
            .margin(.bottom, .xLarge)

            Section {
                Text("Ready to align your server and client?")
                    .font(.title2)
                    .margin(.bottom, .medium)

                Text("Send me a note about your API goals, and we’ll schedule a short call to scope the work.")
                    .margin(.bottom, .small)

                Link("Book a call", target: "mailto:mihaelamj@gmail.com")
                    .role(.primary)
            }
        }
        .padding(.vertical, .xLarge)
    }
}
