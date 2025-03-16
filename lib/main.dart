
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bütçe',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('BÜTÇE')),
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