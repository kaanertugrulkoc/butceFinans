import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final url = 'https://avatars.githubusercontent.com/u/25131682?v=4';

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(url),
                ),
                Text(
                  'Selahattin KOÇ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
