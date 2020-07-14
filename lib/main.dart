import 'package:flutter/material.dart';
import 'photo_edit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PP Süsleyici',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "  EDIT \n  AND \nENJOY",
                  style: TextStyle(
                    wordSpacing: 2,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Fredoka One',
                      color: Colors.red),
                ),
              ),
              height: 150,
              width: 143,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 22.0,
                    color: Colors.amber,
                    blurRadius: 50.0,
                    offset: Offset(1.0, 5.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 45.0,
              child: RaisedButton(
                color: Colors.redAccent,
                child: Text(
                  "START",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'Fredoka One',
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => new PhotoEdit()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}