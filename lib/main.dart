import 'dart:async';
import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:local_notifier/local_notifier.dart';
import 'package:system_tray/system_tray.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localNotifier.setup(
    appName: 'local_notifier_example',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );
  runApp(const MyApp());
  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SystemTray _systemTray = SystemTray();
  final AppWindow _appWindow = AppWindow();

  Timer? _timer;
  bool _toogleTrayIcon = true;

  @override
  void initState() {
    super.initState();
    initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  Future<void> initSystemTray() async {
    String path = Platform.isWindows
        ? 'assets/icons/notifications.ico'
        : 'assets/icons/notifications.png';

    final menu = [
      MenuItem(label: 'Show', onClicked: _appWindow.show),
      MenuItem(label: 'Hide', onClicked: _appWindow.hide),
      MenuItem(
        label: 'Start flash tray icon',
        onClicked: () {
          debugPrint("Start flash tray icon");

          _timer ??= Timer.periodic(
            const Duration(milliseconds: 500),
            (timer) {
              _toogleTrayIcon = !_toogleTrayIcon;
              _systemTray.setImage(_toogleTrayIcon ? "" : path);
            },
          );
        },
      ),
      MenuItem(
        label: 'Stop flash tray icon',
        onClicked: () {
          debugPrint("Stop flash tray icon");

          _timer?.cancel();
          _timer = null;

          _systemTray.setImage(path);
        },
      ),
      MenuSeparator(),
      MenuItem(
        label: 'Exit',
        onClicked: _appWindow.close,
      ),
    ];

    await _systemTray.initSystemTray(
      title: "",
      iconPath: path,
      toolTip: "How to use system tray with Flutter",
    );

    await _systemTray.setContextMenu(menu);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final LocalNotification _exampleNotification = LocalNotification(
    identifier: '_exampleNotification',
    title: "example",
    body: "hello flutter!",
  );

  // List<LocalNotification> _notificationList = [];

  // void callNotification() async {
  //   await localNotifier.setup(
  //     appName: 'desktop_test',
  //     // The parameter shortcutPolicy only works on Windows
  //     shortcutPolicy: ShortcutPolicy.requireCreate,
  //   );
  //
  //   LocalNotification notification = LocalNotification(
  //     title: "desktop_test",
  //     body: "hello flutter!",
  //   );
  //   notification.onShow = () {
  //     print('hello');
  //     print('onShow ${notification.identifier}');
  //   };
  //   notification.onClose = (closeReason) {
  //     // Only supported on windows, other platforms closeReason is always unknown.
  //     switch (closeReason) {
  //       case LocalNotificationCloseReason.userCanceled:
  //         // do something
  //         break;
  //       case LocalNotificationCloseReason.timedOut:
  //         // do something
  //         break;
  //       default:
  //     }
  //     // print('onClose ${_exampleNotification?.identifier} - $closeReason');
  //   };
  //   notification.onClick = () {
  //     print('onClick ${notification.identifier}');
  //   };
  //   notification.onClickAction = (actionIndex) {
  //     print('onClickAction ${notification.identifier} - $actionIndex');
  //   };
  //
  //   notification.show();
  // }
  // _handleNewLocalNotification() async {
  //   LocalNotification notification = LocalNotification(
  //     title: "example - ${_notificationList.length}",
  //     subtitle: "local_notifier_example",
  //     body: "hello flutter!",
  //   );
  //   notification.onShow = () {
  //     print('onShow ${notification.identifier}');
  //   };
  //   notification.onClose = (closeReason) {
  //     print('onClose ${notification.identifier} - $closeReason');
  //   };
  //   notification.onClick = () {
  //     print('onClick ${notification.identifier}');
  //   };
  //
  //   _notificationList.add(notification);
  //
  //   setState(() {});
  // }

  @override
  void initState() {
    _exampleNotification.onShow = () {
      print('onShow ${_exampleNotification.identifier}');
    };
    _exampleNotification.onClose = (closeReason) {
      switch (closeReason) {
        case LocalNotificationCloseReason.userCanceled:
          // do something
          break;
        case LocalNotificationCloseReason.timedOut:
          // do something
          break;
        default:
      }
      String log = 'onClose ${_exampleNotification.identifier} - $closeReason';
      print(log);
      // BotToast.showText(text: log);
    };
    _exampleNotification.onClick = () {
      String log = 'onClick ${_exampleNotification.identifier}';
      print(log);
      // BotToast.showText(text: log);
    };
    _exampleNotification.onClickAction = (actionIndex) {
      String log =
          'onClickAction ${_exampleNotification.identifier} - $actionIndex';
      print(log);
      // BotToast.showText(text: log);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // callNotification();
            // _handleNewLocalNotification();
            _exampleNotification.show();
            const snackBar = SnackBar(content: Text('Hello'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Text('Send local notification!'),
        ),
      ),
    );
  }
}
