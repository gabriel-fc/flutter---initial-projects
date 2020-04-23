import 'package:flutter/material.dart';

final List<dynamic> _taskList = [
  {'status': true, 'id': 'jonhson'},
  {'status': false, 'id': 'dfsdfs'},
  {'status': true, 'id': 'eueueueue'}
];

final TextEditingController txtCtrl = TextEditingController();
final FocusNode txtFocus = FocusNode();

void main() => runApp(MaterialApp(
  theme: ThemeData(
    scaffoldBackgroundColor: Colors.white
  ),
      title: "task list",
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Lista de Tarefas",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: Body(),
      ),
    ));

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}



class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  focusNode: txtFocus,
                  controller: txtCtrl,
                  decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.lightBlue)),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  if (txtCtrl.text == "") return;
                  setState(() {
                    _taskList.add({'id': txtCtrl.text, 'status': false});
                  });
                  txtFocus.unfocus();
                  txtCtrl.text = "";
                },
                color: Colors.lightBlue,
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        Expanded(child: TaskListWidget()),
      ],
    );
  }
}

class TaskListWidget extends StatefulWidget {
  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  Widget _listItem(BuildContext context, index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        alignment: Alignment(1, 0),
        color: Colors.red,
        child: Icon(Icons.delete_outline),
      ),
      onDismissed: (direction) {
        setState(() {
          _taskList.removeAt(index);
        });
      },
      child: Container(
        padding: EdgeInsets.all(3),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Icon(_taskList[index]["status"]
                  ? Icons.done_outline
                  : Icons.error_outline),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${_taskList[index]['id']}"),
            )),
            Checkbox(
                value: _taskList[index]['status'],
                onChanged: (value) {
                  setState(() {
                    _taskList[index]['status'] = value;
                  });
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child:
          ListView.builder(itemBuilder: _listItem, itemCount: _taskList.length),
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _taskList.sort((a, b) {
        if (a['status'] == false && b['status'] == true)
          return 1;
        else if (a['status'] == b['status'] && a["id"].compareTo(b["id"]) == 1)
          return 1;
        else
          return 0;
      });
    });
  }
}
