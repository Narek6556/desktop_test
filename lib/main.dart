import 'package:flutter/material.dart';
import 'package:local_notifier/local_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localNotifier.setup(
    appName: 'local_notifier_example',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
