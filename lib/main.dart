import 'package:flutter/material.dart';
import 'package:sheidaie/pages/poets.dart';
import 'package:sheidaie/widgets/player.dart';

void main() => runApp(const MyApp());

final _navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFAFAFA),
        fontFamily: 'Samim',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

MusicPlayer musicPlayer = MusicPlayer();

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          final NavigatorState navigator =
              Navigator.of(_navigatorKey.currentContext!);

          if (!navigator.canPop()) return true;
          navigator.pop();
          return false;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Navigator(
                key: _navigatorKey,
                onGenerateRoute: (RouteSettings settings) {
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (BuildContext context) => const PoetsListPage(),
                  );
                },
              ),
              musicPlayer
            ],
          ),
        ),
      ),
    );
  }
}
