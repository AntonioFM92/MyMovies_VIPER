- [SDOSSwiftExtension](#sdosswiftextension)
  - [Introducción](#introducci%C3%B3n)
  - [Instalación](#instalaci%C3%B3n)
    - [Cocoapods](#cocoapods)
  - [Cómo se usa](#c%C3%B3mo-se-usa)
    - [Estílos](#est%C3%ADlos)
  - [Referencias](#referencias)

# SDOSSwiftExtension

- Enlace confluence: https://kc.sdos.es/x/DALLAQ
- Changelog: https://svrgitpub.sdos.es/iOS/SDOSSwiftExtension/blob/master/CHANGELOG.md

## Introducción
SDOSSwiftExtension implementa nuevas funcionalidades con el fin de añadir más potencia al lenguaje. Cómo norma general se crearán extensiones de las clases existentes añadiendo nuevas funcionalidades pero también es posible que se creen nuevos componentes con el fin de facilitar el uso del lenguaje

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSSwiftExtension', '~>1.0.2' 
```

## Cómo se usa

La librería en sí no es una implementación de una funcionalidad independiente, por lo que el desarrollador la usará en caso de necesitar alguno de los métodos de utilidad que ésta implemente.

### Estílos

Entre las funcionalidades que implementa contiene la aplicación de estílos para las vistas. Para aplicar estilos a una vista, está debe implementar el protocolo `Stylable`. Este protocolo marca los componentes que pueden ser usados por el struct `Style` que contiene la lógica para la aplicación de estilos. Por defecto las clases `UIView` y `UIViewController` (y todas sus subclases) implementan el protocolo y son candidatos a la aplicación de estilos.
```js
/// Extensión de UIView para poder aplicar estilos sobre él
extension UIView: Stylable { }

/// Extensión de UIViewController para poder aplicar estilos sobre él
extension UIViewController: Stylable { }
```

Para crear nuevos estílos hay que crear extensiones de la clase que se requiera y crear *variables estáticas* o *métodos estáticos* (este caso es si necesitamos pasarle parámetros) que devuelvan el tipo `Style<Class>`. Estás extensiones las crearemos en el fichero `Style+Design.swift`

Estílo para `UIView` que pone el *background color* en azul
``` js
extension UIView {
    enum style {
        typealias View = UIView
        
        ///Apply with the next line: UIView.style.main.apply(to: view)
        static var main: Style<View> {
            return Style<View> {
                $0.backgroundColor = .blue
            }
        }
    }
}   
```

Estílo para `UILabel` que cambia el color y el tamaño de la fuente
``` js
extension UILabel {
    enum style {
        typealias View = UILabel
        
        ///Apply with the next line: UILabel.style.title.apply(to: label)
        static var title: Style<View> {
            return Style<View> {
                $0.font = UIFont.boldSystemFont(ofSize: 25)
                $0.textColor = .white
            }
        }
    }
}
```

Para aplicar los estílos llamaremos a la variable o método estáticos donde tengamos la vista disponible:

``` js
func loadUI() {
    UIView.style.main.apply(to: self.viewBackgorund)
    UILabel.style.title.apply(to: self.lbTitle)
}
```

## Referencias
* https://svrgitpub.sdos.es/iOS/SDOSSwiftExtension
