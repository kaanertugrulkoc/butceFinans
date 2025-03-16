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
        floatingActionButton: FloatingActionButton(onPressed: () {}, child:Icon(Icons.access_alarm),),
        body: Center(
          child: Column(children: [
            TextButton(onPressed: () {}, child: Text("Alarm Kur")),
            TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.access_alarm),
                label: Text("Alarm Kur")),
            ElevatedButton(onPressed: () {}, child: Text('Alarm Kur')),
            ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.access_alarm),
                label: Text('Alarm Kur')),
            OutlinedButton(onPressed: () {}, child: Text('Alarm Kur')),
            OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.access_alarm),
                label: Text('Alarm Kur'))
          ]),
        ),
      ),
    );
  }
}
