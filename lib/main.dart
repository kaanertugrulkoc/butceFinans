
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bütçemiz',
      home: Scaffold(
        appBar: AppBar(
          title: Text('BÜTÇE'),
        ),
        body: Center(
          child: Container(
            child: Text('Anasayfa'),
          ),
        ),
      ),
    );
  }
}