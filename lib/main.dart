import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ganjoor/models/poet/poet.dart';
import 'package:ganjoor/pages/poets.dart';
import 'package:ganjoor/services/ganjoor_service.dart';
import 'package:ganjoor/services/request.dart';
import 'package:ganjoor/widgets/poet.dart';
import 'package:ganjoor/widgets/search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: PoetsListPage(),
    );
  }
}
