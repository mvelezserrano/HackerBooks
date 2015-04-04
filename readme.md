#HackerBooks#
**by Miguel Ángel Vélez Serrano**


**1.¿En que se distingue isKindOfClass de isMemberOfClass?**

El método 'isKindOfClass' comprueba si el objeto pertenece a la clase indicada por parámetro o a cualquier clase que herede de ella, mientras que el método 'isMemberOfClass' únicamente comprueba si el objeto pertenece a la clase indicada por parámetro.

Ambos métodos devuelven un BOOL, indicando si pertenece (YES) o no (NO).


**2.¿Donde guardarías las imágenes de portada y los PDFs?**

Tanto las imágenes de portada, como los PDFs los guardo en la carpeta Documents de la Sandbox. Recupero la url del directorio instanciando un objeto de la clase NSFileManager y enviando el mensaje URLsForDirectory:inDomans:, quedándome con la primera URL:

```
NSFileManager *fm = [NSFileManager defaultManager];
NSArray *urls = [fm URLsForDirectory:NSDocumentDirectory
                               inDomains:NSUserDomainMask];
NSURL *documentsUrl = [urls lastObject];
```


**3.¿Como harías para persistir la información 'isFavorite' de cada libro? ¿Se te ocurre más de una forma de hacerlo?**

Para persistir la información de 'isFavorite' utilizo NSUsersDefault, almacenando un NSDictionary que contiene todos los libros, donde la key es el libro del título y el valor para cada libro es un BOOL indicando si es favorito (YES) o no lo es (NO).

Otra posible forma de hacerlo sería serializar la información en un JSON, utilizando NSJSONSerialization, pero dado que la información contenida en el diccionario de libros que he indicado antes es muy pequeña, creo que es mejor y más rápido utilizar NSUsersDefault.


**4.¿Como enviarías información de un AGTBook a un AGTLibraryTAbleViewController?**

Notifico el cambio de favorito mediante una notificación, llamada 'BOOK_FAVORITE_NOTIFICATION_NAME'. Mediante target/action, al cambiar el switch llamamos al método 'setFavorite' implementado en el AGTBookViewController. Este cambia la propiedad 'isFavorite' del libro y seguidamente envía la notificación.

Esta notificación la recibe el AGTLibraryTableViewController, la cuál actualiza el estado de los favoritos de la librería y después actualiza la información mostrada mediante 'reloadData', mostrando o quitando el libro del tag 'Favorites'.

Creo que era la forma más eficiente de hacerlo, porque meterme en delegados de delegados, mediante 3 saltos.... demasiado lío.


**5.¿Es una aberración desde el punto de rendimiento volver a cargar datos que en su mayoría ya estaban correctos?**

Considero que no es una aberración ya que el UITableViewController únicamente va actualizando la información de las celdas que se muestran en ese momento en la vista, las cuales no superarían las 8 o 10, dependiendo del tamaño del dispositivo de visualización.


**6.Cuando el usuario cambia en la tabla el libro seleccionado, el AGTSimplePDFViewController debe de actualizarse, ¿Como lo harías?**

Desde el AGTLibraryTableViewController envío una notificación, que he llamado `BOOK_DID_CHANGE_NOTIFICATION_NAME` , a la cuál se suscribe el AGTSimpePDFViewController. Cuando éste la recibe, actualiza el PDF mostrado por el del libro que ha recibido mediante la notificación.