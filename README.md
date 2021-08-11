# MyMovies
Finding movies using OMDb API

## Entorno de desarrollo
- iOS 12.4
- Xcode 10.3
- Swift 5

## Features
App desarrollada basándose en el patrón (MVP) modelo vista presentador.

Consta de cuatro vistas principales enlazadas con la navegabilidad que aporta el TabBar y Navigation Controller:
- Una vista principal en la que se realizan llamadas para obtener un listado de películas según su título.
Las llamadas se realizan atendiendo a la palabra escrita cuando esta sea mayor de tres caracteres para evitar una sobrecarga de peticiones.
- Una vista de detalle en la que se muestran datos más detallados.
Se permite además, hacer tap en la imagen para ampliarla al tamaño completo de pantalla y se podrá guardar en el carrete con una pulsación prolongada.
El texto de la sinopsis de la película puede ser copiado al portapapeles y el enlace web compartido por alguna aplicación.
- Una segunda vista que cargará las películas favoritas almacenadas localmente en la memoria local mediante CoreData0.
- Una tercera vista que cargará las películas que han sido compartidas por los usuarios de la aplicación.
- Una cuarta vista que permitirá ver las librerías que se han usado en el proyecto mediante cocoapods y abrirlas en el explorador para ver más información en GitHub.

## Librerías CocoaPods
Se utilizan en el desarrollo las librerías de 
- [Alamofire](https://github.com/Alamofire/Alamofire) para las peticiones a la API de OMDb
- [ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) para mapear los modelos de datos recibidos de estas peticiones.
- [SDOSLoader](https://github.com/SDOSLabs/SDOSLoader)
- [SDOSEnvironment](https://github.com/SDOSLabs/SDOSEnvironment)
- [SDOSPluggableApplicationDelegate](https://github.com/SDOSLabs/SDOSPluggableApplicationDelegate)
- [SDWebImage](https://github.com/SDWebImage/SDWebImage)

Todas ellas añadidas al proyecto usando cocoapods.
