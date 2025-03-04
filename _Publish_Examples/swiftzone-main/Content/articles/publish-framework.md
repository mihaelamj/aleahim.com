---
date: 2021-12-06 07:00
description: Publish framework es un generador de sitios estáticos desarrollado por John Sundell y creado específicamente para desarrolladores de Swift. Permite crear sitios web completos con Swift y admite temas, plugins y toneladas de otras opciones de personalización potentes.
tags: publish, server side, web develoment
title: Publish Framework 
topic: Development
---

<p align="center" margin-top="10px">
    <img src="/images/blog/PublishLogo.png" width="400" max-width="90%" alt="Publish" />
</p>

Publish framework es un generador de sitios estáticos desarrollado por John Sundell y creado específicamente para desarrolladores de Swift. Permite crear sitios web completos con Swift y admite temas, plugins y toneladas de otras opciones de personalización potentes.

Cuando se usa Publish, cada sitio web se define como un paquete Swift, que actúa como la configuración de cómo se debe generar e implementar el sitio web, todo utilizando código Swift nativo y de tipo seguro. 

# Instalación 

Publish se distribuye utilizando Swift Package Manager. Para instalarlo en un proyecto, agréguelo como una dependencia dentro de su manifiesto Package.swift:

```swift 
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.1.0")
    ],
    ...
)
```

Luego, importe Publish donde quiera usarlo:
```swift
import Publish
```

Publish también incluye una herramienta de línea de comandos que facilita la configuración de nuevos proyectos de sitios web y la generación e implementación de los existentes. Para instalar esa herramienta de línea de comando, simplemente ejecute make dentro de una copia local del repositorio de publicación:

```sh
$ git clone https://github.com/JohnSundell/Publish.git
$ cd Publish
$ make
```

A continuación, ejecute `publish help` para obtener instrucciones sobre cómo utilizarla.<br></br>


La herramienta de línea de comando Publicar también está disponible a través de Homebrew y se puede instalar usando el siguiente comando si tiene Homebrew instalado:

```sh
brew install publish
```
# Inicio rápido

Para comenzar rápidamente con Publish, instale la herramienta de línea de comando clonando primero este repositorio y luego ejecute `make` dentro de la carpeta clonada:

```
$ git clone https://github.com/JohnSundell/Publish.git
$ cd Publish
$ make
```
_**Nota**: Si encuentra un error al ejecutar `make`, asegúrese de tener la ubicación de las herramientas de línea de comandos configurada en las preferencias de Xcode. Está en Preferencias> Ubicaciones> Ubicaciones> Herramientas de línea de comandos. El menú desplegable estará en blanco si aún no se ha configurado._

Luego, cree una nueva carpeta para su nuevo proyecto de sitio web y simplemente ejecute `publish new` dentro de ella para comenzar:

```sh
$ mkdir MyWebsite
$ cd MyWebsite
$ publish new
```

Finalmente, ejecute `open Package.swift` para abrir el proyecto en Xcode y comenzar a construir su nuevo sitio web.

# Server

Para iniciar el servidor de desarrollo ejecute en la raíz del proyecto `publish run` y le mostrara un mensaje en consola con la url a consultar.

# Comience de manera simple y personalice cuando sea necesario

Cada sitio web creado con Publish puede decidir libremente qué tipo de secciones y metadatos desea admitir. Arriba, agregamos tres secciones: Recetas, Vínculos y Acerca de, que luego pueden contener cualquier cantidad de elementos. También hemos agregado soporte para nuestros propios metadatos de elementos específicos del sitio a través del tipo ItemMetadata, que podremos usar de manera totalmente segura durante todo el proceso de publicación.

```swift 
struct DeliciousRecipes: Website {
    enum SectionID: String, WebsiteSectionID {
        case recipes
        case links
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var ingredients: [String]
        var preparationTime: TimeInterval
    }

    var url = URL(string: "https://cooking-with-john.com")!
    var name = "Delicious Recipes"
    var description = "Many very delicious recipes."
    var language: Language { .english }
    var imagePath: Path? { "images/logo.png" }
}
```

Si bien Publish ofrece una API realmente poderosa que permite personalizar y ajustar casi todos los aspectos del proceso de generación de sitios web, también incluye un conjunto de API de conveniencia que tiene como objetivo hacer que comenzar sea lo más rápido y fácil posible.

Para comenzar a generar el sitio web de Delicious Recipes que definimos anteriormente, todo lo que necesitamos es una sola línea de código, que le dice a Publish qué tema usar para generar el HTML de nuestro sitio web:

```swift 
try DeliciousRecipes().publish(withTheme: .foundation)
```

*La llamada anterior no solo representa el HTML de nuestro sitio web, sino que también genera una fuente RSS, un mapa del sitio y más.*

Anteriormente, usamos el tema básico integrado de Publish, que es un tema muy básico que se proporciona principalmente como punto de partida y como ejemplo de cómo se pueden crear los temas de Publish. Por supuesto, podemos reemplazar ese tema en cualquier momento por uno propio y personalizado, que puede incluir cualquier tipo de HTML y recursos que queramos.

De forma predeterminada, Publish generará el contenido de un sitio web en función de los archivos Markdown colocados dentro de la carpeta `Content` de ese proyecto, pero también se puede agregar mediante programación cualquier número de elementos de contenido y páginas personalizadas.

**Publish admite tres tipos de contenido:**

**Sections**, que se crean en función de los miembros de la enumeración `SectionID` de cada sitio web. Cada sección tiene su propia página HTML y también puede actuar como un contenedor para una lista de **Items**, que representan las páginas HTML anidadas dentro de esa sección. Finalmente, **Pages** proporciona una forma de crear páginas personalizadas de formato libre que se pueden colocar en cualquier tipo de jerarquía de carpetas.

Cada `Section`, `Items` y `Page` puede definir su propio conjunto de Contenido, que puede variar desde texto (como títulos y descripciones) hasta HTML, audio, video y varios tipos de metadatos.

A continuación, le mostramos cómo podríamos extender nuestra llamada básica `publish()` desde antes para inyectar nuestra propia canalización de publicación personalizada, lo que nos permite definir nuevos elementos, modificar secciones y mucho más:

```swift
try DeliciousRecipes().publish(
    withTheme: .foundation,
    additionalSteps: [
        // Agrega un item mediante código
        .addItem(Item(
            path: "my-favorite-recipe",
            sectionID: .recipes,
            metadata: DeliciousRecipes.ItemMetadata(
                ingredients: ["Chocolate", "Coffee", "Flour"],
                preparationTime: 10 * 60
            ),
            tags: ["favorite", "featured"],
            content: Content(
                title: "Check out my favorite recipe!"
            )
        )),
        // Agrega titulos por defecto a todas las secciones
        .step(named: "Default section titles") { context in
            context.mutateAllSections { section in
                guard section.title.isEmpty else { return }
                
                switch section.id {
                case .recipes:
                    section.title = "My recipes"
                case .links:
                    section.title = "External links"
                case .about:
                    section.title = "About this site"
                }
            }
        }
    ]
)
```

Por supuesto, definir todo el código de un programa en un solo lugar rara vez es una buena idea, por lo que se recomienda dividir las diversas operaciones de generación de un sitio web en pasos claramente separados, que se pueden definir extendiendo el tipo `PublishingStep` con propiedades estáticas o métodos, como este:

```swift
extension PublishingStep where Site == DeliciousRecipes {
    static func addDefaultSectionTitles() -> Self {
        .step(named: "Titulo de secciones por defecto") { context in
            context.mutateAllSections { section in
                guard section.title.isEmpty else { return }
                switch section.id {
                case .recipes:
                    section.title = "My recipes"
                case .links:
                    section.title = "External links"
                case .about:
                    section.title = "About this site"
                }
            }
        }
    }
}
```

*A cada paso de publicación se le pasa una instancia de `PublishingContext`, que puede usar para mutar el contexto actual en el que se publica el sitio web, incluidos sus archivos, carpetas y contenido.*

Con el patrón anterior, podemos implementar cualquier número de pasos de publicación personalizados que se ajusten perfectamente a todos los pasos predeterminados con los que se envía Publish. Esto nos permite construir pipelines realmente poderosos en los que cada paso realiza una sola parte del proceso de generación:

```swift
try DeliciousRecipes().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .addFavoriteItems(),
    .addDefaultSectionTitles(),
    .generateHTML(withTheme: .delicious),
    .generateRSSFeed(including: [.recipes]),
    .generateSiteMap()
])
```
*Arriba, estamos construyendo una canalización de publicación completamente personalizada llamando a la API `publish(using:)`.*

Para obtener más información sobre los pasos de publicación integrados de Publish,[mira este archivo](https://github.com/JohnSundell/Publish/blob/master/Sources/Publish/API/PublishingStep.swift).

# Construyendo un tema HTML

Publish utiliza [Plot] (https://github.com/johnsundell/plot) como motor de creación de temas HTML, que permite definir páginas HTML completas mediante Swift. Al usar Publish, se recomienda que cree su propio tema específico para el sitio web, que puede hacer un uso completo de sus propios metadatos personalizados y adaptarse por completo al diseño de su sitio web.

Los temas se definen utilizando el tipo `Theme`, que utiliza una implementación de` HTMLFactory` para crear todas las páginas HTML de un sitio web. A continuación, se muestra un extracto de cómo se vería la implementación del tema personalizado `.delicious` utilizado anteriormente:

```swift
extension Theme where Site == DeliciousRecipes {
    static var delicious: Self {
        Theme(htmlFactory: DeliciousHTMLFactory())
    }
    private struct DeliciousHTMLFactory: HTMLFactory {
        ...
        func makeItemHTML(
            for item: Item<DeliciousRecipes>,
            context: PublishingContext<DeliciousRecipes>
        ) throws -> HTML {
            HTML(
                .head(for: item, on: context.site),
                .body(
                    .ul(
                        .class("ingredients"),
                        .forEach(item.metadata.ingredients) {
                            .li(.text($0))
                        }
                    ),
                    .p(
                        "This will take around ",
                        "\(Int(item.metadata.preparationTime / 60)) ",
                        "minutes to prepare"
                    ),
                    .contentBody(item.body)
                )
            )
        }
        ...
    }
}
```
Arriba, podemos acceder tanto a las propiedades de elementos integradas como a las propiedades de metadatos personalizados que definimos anteriormente como parte de la estructura `ItemMetadata` de nuestro sitio web, todo ello de una manera que conserva la seguridad de tipo total.

# Creando Plugins

Publish también admite complementos, que se pueden usar para compartir el código de configuración entre varios proyectos o para ampliar la funcionalidad integrada de Publish de varias formas. Al igual que los pasos de publicación, los complementos realizan su trabajo modificando el `PublishingContext` actual, por ejemplo, agregando archivos o carpetas, mutando el contenido existente del sitio web o agregando modificadores de análisis de Markdown.

A continuación, se muestra un ejemplo de un complemento que garantiza que todos los elementos de un sitio web tengan etiquetas:

```swift
extension Plugin {
    static var ensureAllItemsAreTagged: Self {
        Plugin(name: "Ensure that all items are tagged") { context in
            let allItems = context.sections.flatMap { $0.items }
            for item in allItems {
                guard !item.tags.isEmpty else {
                    throw PublishingError(
                        path: item.path,
                        infoMessage: "Item has no tags"
                    )
                }
            }
        }
    }
}
```

Luego, los complementos se instalan agregando el paso `installPlugin` a cualquier canal de publicación:

```swift
try DeliciousRecipes().publish(using: [
    ...
    .installPlugin(.ensureAllItemsAreTagged)
])
```

Para ver un ejemplo del mundo real de un plugin de Publish, consulte el [plugin de Splash] (https://github.com/johnsundell/splashpublishplugin), que facilita la integración del [resaltador de sintaxis de Splash] (https: / /github.com/johnsundell/splash) con Publicar.

# Requisitos del sistema

Para poder utilizar Publish con éxito, asegúrese de que su sistema tenga `Swift versión 5.4 (o posterior) `instalada. Si está utilizando una Mac, asegúrese también de que `xcode-select` esté apuntando a una instalación de Xcode que incluya la versión requerida de Swift, y que esté ejecutando macOS Big Sur (11.0) o posterior.

Tenga en cuenta que Publish **no** admite oficialmente ningún tipo de software beta, incluidas las versiones beta de Xcode y macOS, o versiones inéditas de Swift.
