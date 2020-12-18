import 'package:flutter/material.dart';
import 'package:terminal_launcher/screen/terminal_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launcher',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: TerminalPage(),
    );
  }
}

class MyNewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('sample'),
    );
  }
}
