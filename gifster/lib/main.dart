import 'package:flutter/material.dart';
import 'api_request.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

ThemeData theme() {
  return ThemeData(
      appBarTheme: AppBarTheme(color: Colors.black),
      scaffoldBackgroundColor: Colors.black);
}

void main() => runApp(MaterialApp(
      theme: theme(),
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image.network(
                "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
          ),
          body: HomePage()),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _gifList = List();
  final txtCtrl = TextEditingController();
  final focusCtrl = FocusNode();

  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 5),
        itemBuilder: (context, index) {
          if (txtCtrl.text == "" || index < 19)
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GifPage(_gifList[index]))),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _gifList[index]['images']['fixed_height']['url']),
            );
          else
            return GestureDetector(
              onTap: () {
                setState(() {
                  request(txtCtrl.text, offset: '20')
                      .then((data) => _gifList = data);
                });
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Icon(
                  Icons.refresh,
                  color: Colors.blue,
                  size: 90,
                ),
              ),
            );
        },
        itemCount: (_gifList).length,
      );
    } else
      return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue, style: BorderStyle.solid)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.blue, style: BorderStyle.solid)),

                //focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
              controller: txtCtrl,
              focusNode: focusCtrl,
              onChanged: (value) {
                setState(() {
                  request(value, offset: '0').then((data) => _gifList = data);
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                builder: _builder,
                future: request(txtCtrl.text)
                    .then((onValue) => _gifList = onValue)),
          )
        ],
      ),
    );
  }
}

class GifPage extends StatelessWidget {
  final _data;
  const GifPage(this._data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_data['title']),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_data['images']['original']['url']);
              })
        ],
      ),
      body: Center(
        child: Image.network(_data['images']['original']['url']),
      ),
    );
  }
}
