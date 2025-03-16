import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B Ü T Ç E',
      home: Scaffold(
        appBar: AppBar(
          title: Text('BitirmeProjem BÜTÇE Uygulaması'),
        ),
        body: Center(
          child: Container(
            child: Text('bitirme porjesi bütçe uygulaması'),
          ),
        ),
      ),
    );
  }
}
