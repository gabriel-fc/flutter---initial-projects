import 'package:flutter/material.dart';

class ManageCounter extends StatefulWidget {
  @override
  _ManageCounterState createState() => _ManageCounterState();
}

class _ManageCounterState extends State<ManageCounter> {
  int _count = 0;

  void updateCounter(value) {
    setState(() {
      _count += value;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      Image.asset("lib/images/original.jpg",
        fit: BoxFit.cover,
        height: 1920,
      ),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pessoas: $_count",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "+1",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    onPressed: () => updateCounter(1),
                  ),
                  FlatButton(
                    child: Text(
                      "-1",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    onPressed: () => updateCounter(-1),
                  )
                ],
              ),
            )
          ],
        ),
    ],
  );
}

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: ManageCounter()));
}
