import 'package:flutter/material.dart';
import 'package:flutter_assignment_03/service/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String nametitle = "New Subject";

class Add extends StatefulWidget {
  final int len;

  Add({Key key, @required this.len}) : super(key: key);
  AddfromState createState() {
    // TODO: implement createState
    return AddfromState();
  }
}

class AddfromState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("$nametitle"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 30, 25, 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Subject",
                  hintText: "Please fill Subject",
                  // icon: Icon(Icons.person),
                ),
                controller: _title,
                keyboardType: TextInputType.text,
                onSaved: (subject) => print(subject),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill Subject";
                  }
                },
              ),
              RaisedButton(
                child: Text('Save'),
                onPressed: () {
                  print("save");

                  Firestore.instance
                      .runTransaction((Transaction transaction) async {
                    CollectionReference reference =
                        Firestore.instance.collection('todo');

                    await reference
                        .add({"_id": widget.len + 1, "title": _title.text, "done": 0});
                    _title.clear();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
