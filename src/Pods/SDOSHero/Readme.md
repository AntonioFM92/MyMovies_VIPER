- [SDOSHero](#sdoshero)
    - [Introducción](#introducción)
    - [Instalación](#instalación)
        - [Cocoapods](#cocoapods)
    - [La librería](#la-librería)
        - [Cómo usar SDOSHero](#cómo-usar-sdoshero)
        - [Errores comunes a evitar](#errores-comunes-a-evitar)
    - [Proyecto de ejemplo](#proyecto-de-ejemplo)
    - [Dependencias](#dependencias)
    - [Referencias](#referencias)

# SDOSHero

- Para consultar los últimos cambios en la librería consultar el [CHANGELOG.md](https://svrgitpub.sdos.es/iOS/SDOSHero/blob/master/CHANGELOG.md).

- Enlace confluence: https://kc.sdos.es/x/joDn

## Introducción

SDOSHero ofrece una capa de integración con la librería [Hero](https://github.com/lkzhao/Hero) para:

- Proporcionar acceso desde Objective-C a funciones de la librería [Hero](https://github.com/lkzhao/Hero) que solo pueden usarse con Swift.
- Evitar el hardcodeo de constantes de tipo String para las posibles animaciones entre las vistas.
- Facilitar el uso de [Hero](https://github.com/lkzhao/Hero) para animar las transiciones entre View Controllers.

Usamos [Hero](https://github.com/lkzhao/Hero) para personalizar las animaciones de las transiciones en nuestras aplicaciones.

**Importante**. Es recomendable consultar la documentación de la librería [Hero](https://github.com/lkzhao/Hero) para entender de forma más completa el funcionamiento y el uso de la librería.

## Instalación

### Cocoapods

Usaremos [CocoaPods](https://cocoapods.org). Hay que añadir la dependencia al `Podfile`:

```ruby
pod 'SDOSHero', '~>3.0.0' 
```

## La librería

### Cómo usar SDOSHero

1. **Activar Hero en los `UIViewController` y `UIView` que quieran animarse**. Esto es necesario para animar las transiciones entre `UIViewController`s y `UIView`s se hace accediendo a la propiedad `hero.isEnabled` de la instancia.
```js
lbTitle.hero.isEnabled = true
viewController.hero.isEnabled = true
```
> * **Para las `UIView`**, `hero.isEnabled` tiene el valor `true` por defecto. Por tanto, se recomienda no usar esta propiedad en las `UIView`.
> * **Para los `UIViewController`**, en cambio, `hero.isEnabled` tiene el valor `false` por defecto. Por tanto:
> > * Para que la transición modal hacia un view controller sea animada, esta propiedad deberá setearse en el view controller de destino. Por ejemplo:
> > > 1. Método `prepareForSegue` con `segue.destination.hero.isEnabled = true`.
> > > 2. Justo al instaciar el view controller desde un *storyboard* o *xib*.
> > > 3. En el método `viewDidLoad` del view controller con `self.hero.isEnabled = true`.
> > * Para animar las navegaciones de un `SDOSHeroNavigationController`, se debe setear `hero.isEnabled` a `true`.
> > * Igualmente, para animar el cambio de tab de un `SDOSHeroTabBarController`, se debe setear `hero.isEnabled` a `true`.
> * Aunque `hero.isEnabled` también puede setearse desde el *storyboard* o desde el *xib* (is Hero Enabled), **no es recomendable**. Se debe setear **siembre en código**. 

2. **Animar la transición entre distintos `UIViewController`**. Para ello se utilizan las animaciones del enum `HeroDefaultAnimation`definidas por Hero.

> 2.1. Transiciones **modales** (*present* y *dismiss*).

> * En primer lugar, como se ha mencionado antes, se deberá activar Hero para el view controller a presentar
```js
viewController.hero.isEnabled = true
```

> * Se puede modificar la animación por defecto del *present* o *dismiss* modal de un `UIViewController` de las siguientes maneras:
```js
// Presentación modal de viewController
viewController.animationTypeForPresenting = .pageIn(direction: .up)
 
 
// Ocultación modal de viewController
viewController.animationTypeForDismissing = .pageOut(direction: .down)
   
// Setear la presentación y ocultación modal de viewController simultáneamente
let animationType = HeroDefaultAnimationType.pageIn(direction: .up)
viewController.setHeroAnimationTypeForModalPresenting(animationType, forModalDismissing: animationType.oppositeAnimationType)

 
// Copia las animaciones por defecto de presentación y ocultación de viewController1 en viewController2
viewController2.copyModalSDOSHeroAnimationTypeFrom(viewController: viewController1)
```

> * Se puede modificar la animación de una transición modal justo en el momento de lanzarla:
```js
// Presenta viewController con animación tipo zoom in. Si no se ha seteado el tipo de animación de viewController para la ocultación, al ocultarse (dismiss) este viewController se haría con la animación contraria (zoom out en este caso)
presentViewController(viewController, usingAnimation: .zoom)
 
presentViewController(viewController, usingAnimation: .zoom) {
    // Completion code here
}
 
// Oculta el controlador actual con animación tipo fade
dismissViewControllerUsingAnimation(.fade)

dismissViewControllerUsingAnimation(.fade) {
    // Completion code here
}
 
// Oculta todos los view controllers en el stack modal sin usar ninguna animación para la transición
dismissAllViewControllersUsingAnimation(.none)
 
// Oculta todos los view controllers en el stack modal usando la animación contraria a la animación del último controlador presentado modalmente
dismissAllPresentedViewControllers()
```

> 2.2. Transiciones de ***push*** y ***pop*** de navigation con **SDOSHeroNavigationController**.

> * SDOSHero dispone de la clase **`SDOSHeroNavigationController`**, subclase de `UINavigationController`. Esta clase se encarga de mantener un histórico de animaciones de los *push* de forma que las animaciones de los *pop* de *View Controllers* serán las animaciones "opuestas" correspondientes a las animaciones usadas para cada *push*.
> * Como se indicó antes, para activar la animación con Hero de los *push* y los *pop* de un `SDOSHeroNavigationController`, se debe setear:
```js
navigationController?.hero.isEnabled = true
```
> * Se puede modificar la animación por defecto de los push y pop del SDOSHeroNavigationController de las siguientes maneras:
```js
if let navigationController = navigationController as? SDOSHeroNavigationController {
 
    // Setea la animación por defecto para los push del navigation controller
    navigationController.animationTypeForPush = .pageIn(direction: .up)
 
    // Se puede consultar el tipo de animación por defecto para la presentación y para la ocultación de un view controller específico
    navigationController.animationTypeForPush;
    navigationController.animationTypeForPop;

    // Setea la animación por defecto para los pop del navigation controller   
    navigationController.animationTypeForPop = .pull(direction: .up)
 
    // Setea la animación por defecto para los push y para los pop del navigation controller   
    navigationController.setHeroAnimationTypeForPushNavigations(.pageIn(direction: .up), forPopNavigations: .pull(direction: .up))
}
```

> * Se puede modificar la animación de una transición `push` o `pop` justo en el momento de lanzarla.
```js
if let navigationController = navigationController as? SDOSHeroNavigationController {
    
    // Hacer push con animación específica (el pop se hará con la animación por defecto del Navigation Controller para los pop)
    navigationController.pushViewController(viewController, usingAnimation: .cover(direction: .right))
    
    // Hacer push con animación específica y con la animación contraria para el pop correspondiente
    navigationController.pushViewController(viewController, u   singAnimationForPushAndOppositeForPop: .pull(direction: .up))
    
    // Hacer push con animación específica y pop correspondiente con animación específica
    navigationController.pushViewController(viewController, usingPushAnimation: .zoom, popAnimation: .fade)
    
    // Set view controllers con animación específica
    navigationController.setViewControllers([viewController1, viewController2], usingAnimation: .fade)
    
    // Hacer pop con animación específica
    navigationController.popViewControllerUsingAnimation(.uncover(direction: .down))
    
    // Hacer pop hacia un view controller específico con una animación concreta
    navigationController.popToViewController(viewController, usingAnimation: .zoom)
    
    // Hacer pop hacia el view controller inicial (pop to root view controller) con una animación específica.
    navigationController.popToRootViewController(usingAnimation: .uncover(direction: .up))
    
    // Si se hace pop con el método nativo de UINavigationController, la animación será;
    // * Si se concretó en la petición del push correspondiente, la animación dada.
    // * Si no, se hará con la animación por defecto que tuviera seteada el navigation controller para los pop **en el momento del push**.
    // * Si esa animación fuera .auto o no se hubiera seteado, la animación será la opuesta a la animación que se usó para el push correspondiente.
    navigationController.popViewController(animated: true)
}
```

> * **Importante**: para usar la clase `SDOSHeroNavigationController`desde un *storyboard*, en el *Identity Inspector* del *Navigation Controller*, tras setear la clase a `SDOSHeroNavigationController`, **es necesario rellenar el campo *module* con "SDOSHero"**. De lo contrario, la instancia de ese *Navigation Controller* seguirá siendo de clase `UINavigationController`.

> 2.3. **Tab bar controller con `SDOSHeroTabBarController`**.
> * Con SDOSHero también es posible personalizar la animación de selección de los distintos items de los *Tab Bar Controllers*.
> * Para ello, se debe usar la subclase `SDOSHeroTabBarController`. Esta clase se encarga de animar la transición entre los ítems del *Tab Bar Controller*, manteniendo una coherencia entre las animaciones para la selección de ítems anteriores o posteriores al actual.
> * Para activar la animación con Hero de los cambios del *index* del *tab bar* se debe setear:
```js
tabBarController.hero.isEnabled = true
```
> * Para modificar las animaciones del *Tab Bar Controller*, debe usarse el siguiente método sobre la instancia de `SDOSHeroTabBarController`.
```js
if let tabBarController = tabBarController as? SDOSHeroTabBarController {
    // Este método setea el tipo de animación para las transiciones del Tab Bar Controller con índice mayor al actual. Si el índice de llegada es menor que el actual, se usará la animación opuesta al parámetro `type`
    tabBarController.setTabBarAnimationType(.slide(direction: .left))
}
```

> * **Importante**: para usar la clase `SDOSHeroTabBarController` desde un *storyboard*, en el *Identity Inspector* del *Tab Bar Controller*, tras setear la clase a `SDOSHeroTabBarController`, es necesario rellenar el campo "module" con "SDOSHero". De lo contrario, la instancia de ese *Tab Bar Controller* seguirá siendo de clase `UITabBarController`.


3. **Animación de las vistas en una transición**.
> * Hero ofrece una variedad de animaciones para vistas específicas en las transiciones (modal, de navegación o de selección de un ítem en el *tab bar*).
> * Para ello cada `UIView` tiene:
> > 1. **hero.id**. Se utiliza para configurar la asociación de vistas entre el *view controller* de origen y el de destino de la transición. Si tenemos una transición desde el `viewController1` hacia el `viewController2`, Hero animará las vistas de `viewController1` y `viewController2` que tengan el mismo `hero.id`.
```js
lbTitle.hero.id = "Title_label"
viewController.lbTitle.hero.id = "Title_label"
navigationController.pushViewController(viewController, animated: true)
// En este caso, el lbTitle de self se animará hacia el lbTitle de viewController
```

> > 2. hero.modifiers. *Hero Modifiers* se usan para modificar la animación de una instancia concreta de `UIView` (o subclase) cuando ocurre una transición.
> > > * **Importante**. los *Hero Modifiers* se deben setear en la vista de destino de la transición.
```js
cell.lbTitle.hero.modifiers = [.arc(intensity: 1), .autolayout] 
// Este método fuerza que se respete la posición de la vista definida por el autolayout. Es un parche para un bug de Hero.
lbAnimationReturn.hero.modifiers = [.delay(0.5]
```

### Errores comunes a evitar

1. **Hero IDs duplicados para distintas vistas**. En una transición animada, la librería Hero anima las vistas que tienen el mismo `hero.id`. Esto puede ocasionar que, involuntariamente, configuremos distintas vistas con el mismo `hero.id`, surgiendo así animaciones que no son deseadas. La solución es intentar elegir `hero.id`s lo más concretos y únicos posibles. La mejor solución para evitar duplicados de `hero.id` siempre va a depender del caso concreto que estemos tratando. A continuación mostramos algunos ejemplos.

> * **Problema**: en un listado/detalle, todas las celdas (o vistas específicas incluidas en ellas) se animan hacia una vista de la pantalla detalle, cuando el comportamiento deseado es que eso solo ocurra para la celda seleccionada.   
**Solución propuesta**: incluir en el `hero.id` de la celda (o de la(s) vista(s) de la celda que se quiera animar) un texto que identifique al objeto representado en la celda. Por ejemplo, en un listado de noticias (`News`), el heroIdentifier puede contener el id (identificador) de la noticia.
```js
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellIdentifier") as? NewsTableViewCell else {
        return UITableViewCell()
    }
    
    cell.news = arrayNews[indexPath.row]
    cell.lbTitle.hero.id = "NewsId:" + news.id // El hero.id del label sería "NewsId:1204", por ejemplo.
    cell.lbTitle.hero.modifiers = [.arc(intensity: 1)]
    
    return cell
}
```
> > De esta forma, cada celda tendrá un heroIdentifier único.

> * **Problema**: en ciertas situaciones puede ocurrir que los `hero.id` de vistas en distintos *view controllers* se repitan de forma accidental. Esto podría darse, por ejemplo:
> > * Entre dos view controllers dentro de un mismo `tab bar`.
> > * En pantallas de tipo listado/detalle donde el listado puede cambiar de apariencia (por ejemplo, cambiar de listado a grid). Si usamos los mismos `hero.id` en el listado y en el grid, al cambiar de uno a otro se producirían animaciones entre los ítems que seguramente no deberían ocurrir.   
**Solución propuesta**: el objetivo es que el `hero.id` de cada vista sea lo más "único" posible y solo coincida con la vista asociada en la transición animada. No queremos que coincida por error con otra vista en otro view controller a causa de haber escogido un `hero.id` demasiado genérico. Para esto se pueden seguir diversas estrategias:
> > > a. Que el `hero.id` contenga el nombre del *controlador*. Por ejemplo:
```js
/// NewsListViewController.swift

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellIdentifier") as? NewsTableViewCell else {
        return UITableViewCell()
    }
    
    cell.news = arrayNews[indexPath.row]
    cell.lbTitle.hero.id = String(describing: type(of: self)) + "_NewsId:" + news.id // El hero.id del label sería "NewsListViewController_NewsId:1204", por ejemplo.
    cell.lbTitle.hero.modifiers = [.arc(intensity: 1)]
    
    return cell
}
```
> > En el ejemplo se utiliza prácticamente el mismo código para configurar el `hero.id` del label de la celda, pero gracias a usar el nombre de la clase en el identificador, nos aseguramos de que dicho identificador no se repite entre el listado (table view) y el hipotético grid (collection view), suponiendo que son 2 clases de *view controller* diferentes.

> > > b. Podría ocurrir que la solución anterior no fuera suficiente porque se usara la misma clase para ambos listados (por ejemplo, dos pantallas que comparten el mismo view controller, que contienen un collection view pero cada una usa un UICollectionViewLayout diferente). Si se diera este caso en nuestra app, se podría añadir un UUID a la instancia del propio view controller y añadirlo al `hero.id` para hacerlo único.
```js
/// NewsListViewController.swift

private var uniqueId: String = UUID().uuidString

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellIdentifier") as? NewsTableViewCell else {
        return UITableViewCell()
    }
    
    cell.news = arrayNews[indexPath.row]
    cell.lbTitle.hero.id = uniqueId + "_NewsId:" + news.id // El hero.id del label sería "E621E1F8-C36C-495A-93FC-0C247A3E6E5F_NewsId:1204", por ejemplo.
    cell.lbTitle.hero.modifiers = [.arc(intensity: 1)]
    
    return cell
}
```

## Proyecto de ejemplo

* Descargar el proyecto SDOSHero desde el siguiente enlace: https://svrgitpub.sdos.es/iOS/SDOSHero.
* Ejecutarlo en el dispositivo o simulador y comprobar que, al pulsar en los distintos ítems del *tab bar* y en las distintas celdas de las tablas (cada una correspondiente a un tipo de animación), las transiciones se animan según el tipo de animación seleccionado.

## Dependencias

* [Hero](https://github.com/lkzhao/Hero) 1.4.0

## Referencias

* [Hero](https://github.com/lkzhao/Hero)