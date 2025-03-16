import 'package:flutter/material.dart';

class imagewidget_ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade200,
          title: Text('İmage Widget'),
        ),

        body:Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.asset('assets/images/img.jpg'),
                Text('Resim')

              ],
            ),
          ),
        )
      ),
    );
  }
}
