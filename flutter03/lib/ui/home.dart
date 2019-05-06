import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_assignment_03/service/todo.dart';
import 'package:flutter_assignment_03/ui/add.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String nametitle = "Todo";
  int _currentIndex = 0;
  int lenall = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listbtn = [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          print("Pressed +");
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(len: lenall),
                ),
              );
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          final QuerySnapshot result =
              await Firestore.instance.collection('todo').getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          for (var i = 0; i < documents.length; i++) {
            if (documents[i]['done'] == 1) {
              Firestore.instance
                  .collection('todo')
                  .document(documents[i].documentID)
                  .delete();
            }
          }
        },
      ),
    ];
    final List<Widget> _children = [
      Center(
        child: _buildtodoBody(context),
      ),
      Center(
        child: Center(
          child: _buildundoBody(context),
        ),
      )
    ];
    return Scaffold(
      appBar: AppBar(
          title: Text("$nametitle"), actions: <Widget>[listbtn[_currentIndex]]),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('Task'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.done_all),
            title: new Text('Completed'),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildtodoBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: Text("No data found..."),
          );
        int countlen = 0;
        lenall = snapshot.data.documents.length;
        for (var i = 0; i < snapshot.data.documents.length; i++) {
          if (snapshot.data.documents[i]['done'] == 0) {
            countlen += 1;
          }
        }
        if (countlen == 0) {
          return new Center(
            child: Text("No data found..."),
          );
        } else {
          return _buildtodoList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildundoBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return new Center(
            child: Text("No data found..."),
          );
        int countlen = 0;
        lenall = snapshot.data.documents.length;
        for (var i = 0; i < snapshot.data.documents.length; i++) {
          if (snapshot.data.documents[i]['done'] == 1) {
            countlen += 1;
          }
        }
        if (countlen == 0) {
          return new Center(
            child: Text("No data found..."),
          );
        } else {
          return _buildundoList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildtodoList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildTodoItem(context, data)).toList(),
    );
  }

  Widget _buildundoList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildUndoItem(context, data)).toList(),
    );
  }

  Widget _buildTodoItem(BuildContext context, DocumentSnapshot data) {
    final todo = Todo.fromSnapshot(data);
    if (todo.done == 0) {
      return Padding(
        key: ValueKey(todo.id),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: false,
            ),
            onTap: () => Firestore.instance.runTransaction((transaction) async {
                  final freshSnapshot = await transaction.get(todo.reference);
                  final fresh = Todo.fromSnapshot(freshSnapshot);

                  await transaction
                      .update(todo.reference, {'done': fresh.done = 1});
                }),
          ),
        ),
      );
    } else {
      return Column();
    }
  }

  Widget _buildUndoItem(BuildContext context, DocumentSnapshot data) {
    final todo = Todo.fromSnapshot(data);
    if (todo.done == 1) {
      return Padding(
        key: ValueKey(todo.id),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: true,
            ),
            onTap: () => Firestore.instance.runTransaction((transaction) async {
                  final freshSnapshot = await transaction.get(todo.reference);
                  final fresh = Todo.fromSnapshot(freshSnapshot);

                  await transaction
                      .update(todo.reference, {'done': fresh.done = 0});
                }),
          ),
        ),
      );
    } else {
      return Column();
    }
  }
}
