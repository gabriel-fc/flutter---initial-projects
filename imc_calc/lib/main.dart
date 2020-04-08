import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Calculadora de IMC",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Expanded(
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.android,
                  color: Colors.green,
                  size: 80,
                ),
                TextField(
                  controller: heightController,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      labelText: "Sua altura (cm):",
                      labelStyle: TextStyle(color: Colors.green, fontSize: 25)),
                ),
                Container(height: 20),
                TextField(
                  controller: weightController,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                      labelText: "Seu peso (Kg):",
                      labelStyle: TextStyle(color: Colors.green, fontSize: 25)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
