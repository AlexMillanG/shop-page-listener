# Travis Sneaker Drop Notifier

> Sistema de notificaciones en tiempo real para lanzamientos de sneakers en la tienda de Travis Scott

## Descripcion del Proyecto

Travis Sneaker Drop Notifier es una aplicacion movil desarrollada en Flutter que monitorea y notifica instantaneamente cuando hay lanzamientos de productos en la tienda oficial de Travis Scott. La aplicacion utiliza Firebase Cloud Messaging para enviar notificaciones push en tiempo real, incluso cuando la aplicacion esta en segundo plano o cerrada.

El objetivo principal es alertar a los usuarios inmediatamente cuando se lanzan productos exclusivos, permitiendoles tener una ventaja competitiva en la compra de articulos de edicion limitada.

## Tecnologias Utilizadas

### Frontend
- **Flutter 3.9.2** - Framework multiplataforma para desarrollo de aplicaciones moviles
- **Dart** - Lenguaje de programacion principal

### Backend & Cloud Services
- **Firebase Cloud Messaging (FCM)** - Sistema de mensajeria en la nube para notificaciones push
- **Firebase Core 4.2.1** - SDK principal de Firebase para Flutter

### Notificaciones
- **Firebase Messaging 16.0.4** - Integracion de FCM con Flutter
- **Flutter Local Notifications 17.2.2** - Notificaciones locales nativas
- **Awesome Notifications 0.10.1** - Sistema avanzado de notificaciones con alarmas y pantalla completa

### Herramientas de Desarrollo
- **Flutter Lints 5.0.0** - Analizador de codigo y buenas practicas
- **Flutter Test** - Framework de testing

## Caracteristicas Principales

- **Notificaciones en Tiempo Real**: Recibe alertas instantaneas cuando se detectan nuevos lanzamientos
- **Funcionamiento en Segundo Plano**: Las notificaciones llegan incluso con la app cerrada
- **Alarma de Pantalla Completa**: Notificaciones con sonido de alarma y activacion de pantalla
- **Sistema de Suscripcion por Topicos**: Suscripcion automatica al topico "drops" para recibir alertas
- **Interfaz Simple**: Visualizacion del estado de conexion y token FCM para debugging

## Estructura del Proyecto

```plaintext
travis_alarm/
├── lib/
│   ├── main.dart              # Punto de entrada de la aplicacion
│   └── firebase_options.dart  # Configuracion de Firebase (no incluido)
├── android/
│   └── app/
│       └── google-services.json  # Credenciales Firebase (no incluido)
├── pubspec.yaml               # Dependencias del proyecto
└── README.md                  # Este archivo
```

## Configuracion

### Prerrequisitos

1. Flutter SDK (>=3.9.2)
2. Android Studio / Xcode (para desarrollo Android/iOS)
3. Cuenta de Firebase activa
4. Proyecto de Firebase configurado

### Instalacion

1. Clonar el repositorio:
```bash
git clone <url-del-repositorio>
cd travis_alarm
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Configurar Firebase:
   - Crear un proyecto en [Firebase Console](https://console.firebase.google.com)
   - Descargar `google-services.json` y colocarlo en `android/app/`
   - Ejecutar FlutterFire CLI para generar `firebase_options.dart`:
   ```bash
   flutterfire configure
   ```

4. Ejecutar la aplicacion:
```bash
flutter run
```

## Uso

1. Al abrir la aplicacion por primera vez, se solicitaran permisos de notificaciones
2. La app se suscribe automaticamente al topico "drops"
3. El token FCM se muestra en pantalla para propositos de debugging
4. Las notificaciones llegaran automaticamente cuando se publiquen en el topico "drops"

## Arquitectura de Notificaciones

### Flujo de Trabajo

1. **Inicializacion**: La app inicializa Firebase y configura los canales de notificacion
2. **Suscripcion**: Se suscribe automaticamente al topico "drops" de FCM
3. **Recepcion**: Los mensajes se reciben via FCM
4. **Procesamiento**:
   - **Foreground**: Handler `onMessage` procesa mensajes con la app abierta
   - **Background**: Handler `onBackgroundMessage` procesa mensajes en segundo plano
5. **Notificacion**: Awesome Notifications muestra alertas con sonido y pantalla completa

### Canal de Notificaciones

- **Nombre**: Travis Drop Alarms
- **Importancia**: Maxima
- **Sonido**: Alarma personalizada
- **Vibracion**: Activada
- **Wake Screen**: Si
- **Pantalla Completa**: Si (para alertas urgentes)

## Seguridad y Datos Sensibles

Los siguientes archivos contienen informacion sensible y NO deben incluirse en el control de versiones:

- `android/app/google-services.json`
- `lib/firebase_options.dart`
- `firebase.json`
- Cualquier archivo `.env`

Estos archivos estan excluidos via `.gitignore`.

## Consideraciones de Desarrollo

- La funcion `_firebaseMessagingBackgroundHandler` debe estar marcada con `@pragma('vm:entry-point')` para funcionar correctamente en segundo plano
- Se requieren permisos especiales en Android para alarmas de pantalla completa
- El sistema de notificaciones puede requerir configuracion adicional en iOS

## Licencia

Este proyecto es de portafolio personal y demostrativo.

## Contacto

Para mas informacion sobre este proyecto, puedes contactarme a traves de mi portafolio.

---

**Nota**: Este proyecto fue desarrollado con fines educativos y de portafolio. No se utiliza para propositos comerciales.
