import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

// 🔔 Handler para mensajes en segundo plano
@pragma('vm:entry-point') // 👈 ESTA LÍNEA ES CLAVE
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      channelKey: 'travis_alarm_channel',
      title: message.notification?.title ?? 'Nuevo mensaje',
      body: message.notification?.body ?? '',
      notificationLayout: NotificationLayout.Default,
      wakeUpScreen: true,
      fullScreenIntent: true,
      locked: true,
    ),
  );

  print('📩 Mensaje recibido en segundo plano: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔔 Inicializa Awesome Notifications
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'travis_alarm_channel',
      channelName: 'Travis Drop Alarms',
      channelDescription: 'Canal para alarmas de Travis Dropwatcher',
      importance: NotificationImportance.Max,
      playSound: true,
      soundSource: 'resource://raw/alarm',
      defaultRingtoneType: DefaultRingtoneType.Alarm,
      enableVibration: true,
    ),
  ]);

  // 🔔 Pide permiso para notificaciones locales
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _token;
  String _mensaje = 'Esperando notificación...';

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    await FirebaseMessaging.instance.requestPermission();

    // 🔥 Obtiene el token del dispositivo
    String? token = await FirebaseMessaging.instance.getToken();
    print('🔥 Token FCM: $token');

    // 🔔 Suscribe al topic 'drops'
    await FirebaseMessaging.instance.subscribeToTopic('drops');
    print('📡 Suscrito al topic "drops"');

    setState(() => _token = token);

    // 📬 Escucha mensajes cuando la app está abierta
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _mensaje =
            '📨 ${message.notification?.title}: ${message.notification?.body}';
      });
      print('Mensaje en foreground: ${message.notification?.title}');

      // 🔔 Muestra la notificación con sonido y pantalla encendida
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'travis_alarm_channel',
          title: message.notification?.title ?? 'Nuevo mensaje',
          body: message.notification?.body ?? '',
          notificationLayout: NotificationLayout.Default,
          wakeUpScreen: true,
          fullScreenIntent: true,
          locked: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Prueba Travis Alarm')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                SelectableText(
                  _token ?? 'Obteniendo token...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
