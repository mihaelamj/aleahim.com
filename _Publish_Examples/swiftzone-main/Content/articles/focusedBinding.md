---
title: @FocusedBinding
date: 2020-01-20 13:04
description: El siguiente código apareció en el video en Apple WWDC20, presentando un nuevo envoltorio de atributo @FocusedBinding. Como todavía se encuentra en la fase de prueba, el código actual no se puede ejecutar correctamente. Apple rara vez divulga la información de @FocusedBinding y no hay información relevante en Internet. Por interés personal, realicé una simple investigación al respecto. Aunque @FocusedBinding se ejecuta en la versión actual de Xcode Versión 12.0 beta 2 (12A6163b), todavía hay muchos problemas, pero básicamente lo entiendo bien
tags: SwiftUI
topic: Development
---

> 
El siguiente código apareció en el video en Apple WWDC20, presentando un nuevo envoltorio de atributo @FocusedBinding. Como todavía se encuentra en la fase de prueba, el código actual no se puede ejecutar correctamente. Apple rara vez divulga la información de @FocusedBinding y no hay información relevante en Internet. Por interés personal, realicé una simple investigación al respecto. Aunque @FocusedBinding se ejecuta en la versión actual de Xcode Versión 12.0 beta 2 (12A6163b), todavía hay muchos problemas, pero básicamente lo entiendo bien

```swift
struct BookCommands: Commands {
 @FocusedBinding(\.selectedBook) private var selectedBook: Book?
  var body: some Commands {
    CommandMenu("Book") {
        Section {
            Button("Update Progress...", action: updateProgress)
                .keyboardShortcut("u")
            Button("Mark Completed", action: markCompleted)
                .keyboardShortcut("C")
        }
        .disabled(selectedBook == nil)
    }
  }

   private func updateProgress() {
       selectedBook?.updateProgress()
   }
   private func markCompleted() {
       selectedBook?.markCompleted()
   }
}
```

## Usar ##

**Operaciones de intercambio, modificación y vinculación de datos entre cualquier vista (Vista).**

En SwiftUI1.0, podemos usar EnvironmentKey para pasar datos a la vista secundaria y PreferenceKey para pasar datos a la vista principal. Si queremos transferir datos entre dos vistas paralelas que no están en el mismo árbol de vistas, normalmente necesitamos usar Single of True o mediante NotificationCenter.

En SwiftUI2.0, Apple introdujo @FocusedBinding y @FocusedValue para resolver este problema. Al definir FocusedValueKey, podemos compartir, modificar y vincular datos directamente entre cualquier vista sin pasar por Single of truth.

En [SwiftUI2.0 —— Comandos (menú macOS)] (https://zhuanlan.zhihu.com/p/152127847) en este artículo, pasamos el método Único de verdad, a nivel de aplicación, para que los Commnads puedan compartir datos con otras vistas. A través de los ejemplos proporcionados por WWDC, podemos ver que Apple espera brindar una solución alternativa para completar las funciones mencionadas anteriormente. Del mismo modo, esta solución también nos permite intercambiar datos entre cualquier vista (ya sea en el mismo árbol o no).

## Instrucciones ##

Su uso básico es muy similar al del entorno, primero debe definir la clave especificada

```swift
struct FocusedMessageKey:FocusedValueKey{
    // A diferencia de EnvironmentKey, FocusedValueKey no tiene un valor predeterminado 
    // y debe ser un valor opcional. Para la siguiente demostración, aquí establecemos el 
    // tipo de datos en Binding <String>, que se puede establecer en cualquier tipo de valor de datos
    typealias Value = Binding<String>
}

extension FocusedValues{
    
    var message:Binding<String>?{
        get{self[FocusedMessageKey.self]}
        set{self[FocusedMessageKey.self] = newValue}
    }
}
```

Dado que se puede utilizar en cualquier vista, no es necesario inyectar datos. A diferencia de EnvironmentKey (solo válido en el árbol de vista inyectado actualmente), los datos son válidos en todo el dominio.

```swift
struct ShowView:View{
    // El método de llamada es casi el mismo que @Environment, usar @FocusedValue o 
    // @FocusedBinding requiere un método de referencia diferente
    @FocusedValue(\.message) var focusedMessage
    //@FocusedBinding(\.message) var focusedMessage1
    var body: some View{
        VStack{
        Text("focused:\(focusedMessage?.wrappedValue ?? "")")
        //Text("focused:\(focusedMessage1 ?? "")")
        }
    }
}
```

Modifique los datos de FocusedValueKey en otra vista.

```swift
struct InputView1:View{
    @State private var text = ""
    var body: some View{
        VStack{
        TextField("input1:",text:$text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            // Sincronizar mensaje y texto
            .focusedValue(\.message, $text)
        }
    }
}

```

La misma FocusedValueKey se puede modificar en varias vistas

```swift
struct InputView2:View{
    @State private var text = ""
    var body:some View{
        TextField("input2:",text:$text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .focusedValue(\.message, $text)
    }
}
```

Finalmente ensamblados juntos

```swift
struct RootView: View {
    var body: some View {
        VStack{
            // Las tres vistas están en una relación paralela Antes de utilizar Entorno o  
            // Preferencia, no se puede llevar a cabo la transmisión y el intercambio de 
            // datos entre estas tres vistas.
            InputView1()
            InputView2()
            ShowView()
        }
        .padding(.all, 20)
        .frame(maxWidth:.infinity, maxHeight: .infinity)
    }
}
```

<!--<video src="http://cdn.fatbobman.com/focusebinding-video.mov" controls="controls"> ¡Su navegador no admite la reproducción de este video！</video>-->

Actualmente, el valor de FocusedValueKey no se puede obtener en iOS. El documento indica que es compatible con iOS, lo que debería resolverse en el futuro.

## ¿Cómo se usa, cómo se usa? ##

La introducción de FoccusedBinding mejora aún más la función de manipulación de datos en diferentes vistas de SwiftUI. Sin embargo, mi recomendación personal es no abusar de esta función.

Dado que podemos modificar el valor de la clave en cualquier vista, una vez que se abusa de ella, es probable que caiga en el dilema de que el código es difícil de administrar nuevamente.

Para algunas funciones son muy simples, no es necesario usar el código lógico MVVM, o Single de verdad está demasiado hinchado（[ObservableObject Research: quiero decir que no es fácil amarte](/posts/observableObject-study/)），Para los códigos que pueden causar problemas de respuesta de la aplicación, considere usar el esquema anterior.
