import 'package:flutter/material.dart';

class buttonTur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade200,
          title: Text('Button Türleri'),
        ),
        body: Center(
          child: Column(children: [
            TextButton(onPressed: () {}, child: Text("Tıkla")),
          ]),
        ),
      ),
    );
  }
}
