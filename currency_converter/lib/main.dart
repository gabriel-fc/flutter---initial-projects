import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

final _brlCtrl = TextEditingController();
final _dolCtrl = TextEditingController();
final _eurCtrl = TextEditingController();
var _data;

Future<void> _updateCachedData() async {
  Directory docPath = await getApplicationDocumentsDirectory();
  File doc = File(docPath.path + '/cached-data.json');
  doc.writeAsString(jsonEncode(_data));
 }

Future<void> _getCachedData() async {
  Directory docPath = await getApplicationDocumentsDirectory();
  File doc = File(docPath.path + "/cached-data.json");
  _data = jsonDecode(await doc.readAsString());
}

void _convert(identifier) {
  if (identifier == "real") {
    if (_brlCtrl.text == "") {
      _dolCtrl.text = "";
      _eurCtrl.text = "";
    }
    _dolCtrl.text =
        (_data["USD"] * double.parse(_brlCtrl.text)).toStringAsFixed(2);
    _eurCtrl.text =
        (_data["EUR"] * double.parse(_brlCtrl.text)).toStringAsFixed(2);
  } else if (identifier == "dollar") {
    if (_dolCtrl.text == "") {
      _brlCtrl.text = "";
      _eurCtrl.text = "";
    }
    _brlCtrl.text =
        (double.parse(_dolCtrl.text) / _data["USD"]).toStringAsFixed(2);
    _eurCtrl.text =
        (double.parse(_brlCtrl.text) * _data["EUR"]).toStringAsFixed(2);
  } else {
    if (_eurCtrl.text == "") {
      _dolCtrl.text = "";
      _brlCtrl.text = "";
    }
    _brlCtrl.text =
        (double.parse(_eurCtrl.text) / _data["EUR"]).toStringAsFixed(2);
    _dolCtrl.text =
        (double.parse(_brlCtrl.text) * _data["USD"]).toStringAsFixed(2);
  }
}

Future _getCurrency() async {
  var data =
      await (http.get('https://api.exchangeratesapi.io/latest?base=BRL'));
  _updateCachedData();
  return jsonDecode(data.body);
}

void main() => runApp(MaterialApp(
      title: 'currency conversor',
      home: FutureBuilder(
        future: _getCurrency(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              _getCachedData();
            }
            else {
              _data = snapshot.data["rates"];
              _updateCachedData();
            }

            return Home();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else
            return Container();
        },
      ),
      theme: ThemeData(
          cursorColor: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          hintColor: Colors.orange),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(
          "\$Conversor\$",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(7),
        color: Colors.black,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.monetization_on,
                  color: Colors.orange,
                  size: 100,
                ),
                Container(
                  height: 30,
                ),
                TxtInput("dollar", _dolCtrl),
                Container(
                  height: 15,
                ),
                TxtInput("euro", _eurCtrl),
                Container(
                  height: 15,
                ),
                TxtInput("real", _brlCtrl)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TxtInput extends StatefulWidget {
  final String hintString;
  final TextEditingController textController;

  TxtInput(this.hintString, this.textController);

  @override
  _TxtInputState createState() => _TxtInputState();
}

class _TxtInputState extends State<TxtInput> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      style: TextStyle(
        color: Colors.orange,
      ),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(30)),
        hintText: widget.hintString,
        hintStyle: TextStyle(color: Colors.orange),
      ),
      onChanged: (text) {
        setState(() {
          _convert(widget.hintString);
        });
      },
    );
  }
}
