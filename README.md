# SampleTrack - Practico 2

Desarrollo de Aplicaciones Moviles - G62 - 2026-2

Variante B (pareja): Ximena Ruiz Arias y Victor Manuel Monsalve Aguilar.

Partimos de la shell que entrego el profesor. El catalogo de muestras se dejo
igual en `lib/data/sample_seed.dart`. En Firestore y en Drift solo se guardan
los eventos de cada muestra; el tipo, origen y prioridad de la muestra no se
guardan en `sample_events`, siguen saliendo de la shell.

## Que hicimos

- Agregamos Firebase (proyecto propio `sampletrack-g62`), Cloud Firestore y
  Drift.
- En Firestore usamos la coleccion `sample_events`. Cada documento es un solo
  evento con `id`, `sampleId`, `type` y `createdAt`. El id del documento es el
  mismo campo `id`, asi cada evento queda separado y no se pisan entre ellos.
- En Drift creamos la tabla `sample_events` con esos mismos campos. Se usa como
  cache local de lo que llega de Firestore.
- Al cargar los eventos primero se intenta leer de Firestore. Si funciona, se
  guardan en Drift y se muestran. Si falla, se muestran los que hay en Drift y
  sale el aviso "Sin conexion, mostrando datos guardados".
- El estado de la muestra es el ultimo evento. Si no tiene eventos sale
  "Sin eventos".
- Al registrar un evento primero se revisa que sea el siguiente del flujo
  (RECEIVED, PREPARED, IN_ANALYSIS, VALIDATED, ARCHIVED). Luego se guarda en
  Firestore y despues en Drift. Si Firestore falla se muestra el error y el
  evento no se guarda en ningun lado.

## Variante B

Entre PREPARED e IN_ANALYSIS tienen que pasar minimo 10 minutos. Los 10
minutos se cuentan desde el `createdAt` del evento PREPARED. Si se intenta
antes, no se deja registrar y sale un mensaje con lo que falta, por ejemplo
"Faltan aproximadamente 8 min 50 s". En el detalle tambien se ve cuanto falta
y se va actualizando cada segundo.

La logica esta en `lib/domain/sample_transitions.dart` (`validate` y
`remainingForAnalysis`).

## Estructura

- `lib/models`: Sample (de la shell), SampleEvent y los tipos de evento.
- `lib/domain`: reglas de transicion, variante B y los errores.
- `lib/database`: tabla de Drift, la base y `SampleEventLocalDataSource` con
  las consultas.
- `lib/services`: lectura y escritura en Firestore.
- `lib/repositories`: une Firestore y Drift. Las pantallas solo hablan con el
  repository.
- `lib/pages` y `lib/widgets`: pantallas.

## Algunas decisiones

- Desactivamos la cache propia de Firestore (`persistenceEnabled: false`) porque
  la cache local es Drift. Si la dejabamos, Firestore respondia con su cache y
  nunca se veia el fallback.
- A la lectura de Firestore le pusimos un limite de 15 segundos. Sin internet
  Firestore se demora mucho en fallar y la app se quedaba cargando.
- En Drift las fechas se guardan como texto (`build.yaml`) para no perder los
  milisegundos y que el orden de los eventos salga bien.
- Las reglas de Firestore (`firestore.rules`) solo dejan crear eventos con los
  4 campos y un `type` valido. No dejan editar ni borrar, para que el historial
  se conserve.

## Como correrlo

```bash
flutter pub get
flutter run
```

Si se cambia la tabla de Drift hay que regenerar el codigo:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Las reglas de Firestore se suben con:

```bash
firebase deploy --only firestore:rules
```

## Como probarlo

- Variante B: entrar a una muestra, registrar Recibida, luego Preparada, e
  intentar En analisis. Debe salir el mensaje con el tiempo que falta.
- Transicion invalida: con "Registrar otro evento" se puede escoger cualquier
  evento, por ejemplo Validada en una muestra Recibida. La app no lo deja.
- Fallback: con datos ya cargados, poner el emulador en modo avion y tocar
  actualizar. Sale el aviso y se siguen viendo los eventos guardados en Drift.

## Pruebas

```bash
flutter test
```

Hay pruebas de las transiciones, de la variante B y del repositorio. Para el
repositorio usamos Drift en memoria y un Firestore falso
(`test/fake_remote_service.dart`) para simular cuando no hay conexion.

## Problemas que tuvimos

- En la red de la U el emulador no tenia internet: el PC tenia DNS fijos
  (8.8.8.8, 1.1.1.1) que la red bloquea, y la app siempre mostraba los datos
  locales. Se soluciono pasandole al emulador el DNS de la red.
- El emulador se comia la RAM del PC (16 GB). Bajamos la memoria del emulador y
  de Gradle.

Para eso dejamos el script `tool\emulador.ps1` (opcional, esta configurado para
nuestro PC):

```powershell
powershell -ExecutionPolicy Bypass -File tool\emulador.ps1
```
