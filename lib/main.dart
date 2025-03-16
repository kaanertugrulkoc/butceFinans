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
        backgroundColor: Colors.blueGrey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade200,
          centerTitle: true,
          title: Text('Hakkımda'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(url),
              ),
              Text(
                'Selahattin KOÇ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Software Developer',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              Card(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('https://www.instagram.com/kaanertugrulkocofficial',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [Text('1.5K', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        Text('Takipçi')
                        ],
                      )),
                      Expanded(
                          child: Column(
                            children: [Text('0', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                              Text('Takip')
                            ],
                          )),
                      Expanded(
                          child: Column(
                            children: [Text('37', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                              Text('Paylaşım')
                            ],
                          ))
                    ],
                  )
                ],
              )),
            ]),
          ),
        ),
      ),
    );
  }
}
