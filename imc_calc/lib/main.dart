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
  final focusHeight = FocusNode();
  final focusWeight = FocusNode();

  var _value = "";

  void calculate() {
    setState(() {
      if (heightController.text == "" || weightController.text == "") {
        _value = "entrada inválida!";
        return;
      }
      var height = double.parse(heightController.text);
      var weight = double.parse(weightController.text);

      height = height / 100;
      _value = (weight / (height * height)).toStringAsFixed(2);
      if (focusHeight.hasFocus) focusHeight.unfocus();
      if (focusWeight.hasFocus) focusWeight.unfocus();
    });
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(
                Icons.android,
                color: Colors.green,
                size: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                onEditingComplete: () {
                  focusWeight.requestFocus();
                },
                focusNode: focusHeight,
                keyboardType: TextInputType.number,
                controller: heightController,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                    labelText: "Sua altura (cm):",
                    labelStyle: TextStyle(color: Colors.green, fontSize: 25)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                focusNode: focusWeight,
                keyboardType: TextInputType.number,
                controller: weightController,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                    labelText: "Seu peso (Kg):",
                    labelStyle: TextStyle(color: Colors.green, fontSize: 25)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                //constraints: BoxConstraints(maxHeight: 10),
                child: RaisedButton(
                  color: Colors.green,
                  child: Text("Calcular"),
                  onPressed: calculate,
                ),
              ),
            ),
            Text(
              "$_value",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
