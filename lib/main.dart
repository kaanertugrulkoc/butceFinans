import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'B Ü T Ç E',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Hakkımda'),
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
