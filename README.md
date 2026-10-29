# SampleTrack - Examen Practico 2

Variante B (pareja): Ximena Ruiz Arias y Victor Manuel Monsalve Aguilar.

Partimos de la shell que entrego el profesor. El catalogo de muestras se dejo
igual en `lib/data/sample_seed.dart`; en Firestore y en Drift solo se guardan
los eventos de cada muestra.

## Que hicimos

- Agregamos Firebase (proyecto `sampletrack-g62`), Cloud Firestore y Drift.
- En Firestore usamos la coleccion `sample_events`. Cada documento es un
  evento con `id`, `sampleId`, `type` y `createdAt`.
- En Drift creamos la tabla `sample_events` con esos mismos campos. Se usa
  como cache local.
- Al abrir una muestra se intenta leer de Firestore. Si funciona, se guardan
  los eventos en Drift. Si falla, se muestran los que hay en Drift y sale un
  aviso de que son datos locales.
- El estado de la muestra es el ultimo evento. Si no tiene eventos sale
  "Sin eventos".
- Al registrar un evento primero se revisa que sea el siguiente del flujo
  (RECEIVED, PREPARED, IN_ANALYSIS, VALIDATED, ARCHIVED). Luego se guarda en
  Firestore y despues en Drift. Si Firestore falla se muestra el error y el
  evento no se guarda.

## Variante B

Entre PREPARED e IN_ANALYSIS tienen que pasar minimo 10 minutos. Si se intenta
antes, no se deja registrar y se muestra cuanto falta. En el detalle tambien
hay un contador mientras la muestra esta en PREPARED.

La logica esta en `lib/domain/sample_transitions.dart`.

Para probarla: registrar Recibida, luego Preparada, e intentar En analisis.
Debe salir el mensaje con el tiempo que falta.

El boton "Registrar otro evento" sirve para intentar registrar cualquier evento
y ver que los saltos de estado se bloquean.

## Estructura

- `lib/models`: Sample, SampleEvent y los tipos de evento.
- `lib/domain`: reglas de transicion y la variante B.
- `lib/database`: tabla y base de datos de Drift.
- `lib/services`: lectura y escritura en Firestore.
- `lib/repositories`: une Firestore y Drift (remoto primero, local si falla).
- `lib/pages` y `lib/widgets`: pantallas.

## Como correrlo

```bash
flutter pub get
flutter run
```

Si se cambia la tabla de Drift hay que regenerar el codigo:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Las reglas de Firestore estan en `firestore.rules` y se suben con:

```bash
firebase deploy --only firestore:rules
```

Para abrir el emulador sin que se llene la RAM:

```powershell
powershell -ExecutionPolicy Bypass -File tool\emulador.ps1
```

El script le pasa al emulador el DNS de la red. En la red de la U, si el PC
tiene DNS fijos (8.8.8.8, 1.1.1.1), el emulador se queda sin internet y la app
muestra los datos locales.

## Pruebas

```bash
flutter test
```

Hay pruebas de las transiciones, de la variante B y del repositorio (con Drift
en memoria y un Firestore falso para simular cuando no hay conexion).
