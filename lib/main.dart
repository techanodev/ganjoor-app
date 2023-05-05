import 'package:flutter/material.dart';
import 'package:ganjoor/pages/poem_detail.dart';
import 'package:ganjoor/pages/poet_detail.dart';
import 'package:ganjoor/pages/poets.dart';
import 'package:ganjoor/widgets/player.dart';
import 'package:miniplayer/miniplayer.dart';

void main() => runApp(MyApp());

final _navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Miniplayer example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFFAFAFA),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Widget> HomePage = [];
MusicPlayer musicPlayer = MusicPlayer();
Function gSetState = () {};

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    gSetState = () {
      setState(() {
        print('object');
      });
    };
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
                    builder: (BuildContext context) => PoetsListPage(),
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
