import 'package:TodoApp/screens/todoDetails.dart';
import 'package:flutter/material.dart';
import 'package:TodoApp/utils/dbhelper.dart';
import 'package:TodoApp/model/todo.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  DbHelper dbHelper = DbHelper();
  List<Todo> todos;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
    return Scaffold(
      body: todoListItem(),
      floatingActionButton: FloatingActionButton(
          onPressed: () => navigateToDetails(Todo('', 3, '')),
          tooltip: "Add",
          child: Icon(Icons.add)),
    );
  }

  ListView todoListItem() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.todos[position].priority),
              child: Text(
                this.todos[position].id.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Text(this.todos[position].title),
            subtitle: Text(this.todos[position].date),
            onTap: () {
              navigateToDetails(this.todos[position]);
              debugPrint('Tapped on ' + this.todos[position].id.toString());
            },
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = dbHelper.initializeDb();
    dbFuture.then((value) {
      final todosFuture = dbHelper.getTodos();
      todosFuture.then((results) {
        List<Todo> todosList = List<Todo>();
        int todosCount = results.length;
        for (var i = 0; i < todosCount; i++) {
          todosList.add(Todo.fromObject(results[i]));
          debugPrint(todosList[i].title);
        }
        setState(() {
          todos = todosList;
          count = todosCount;
        });
        debugPrint("Items: $todosCount");
      });
    });
  }

  Color getColor(int priority) {
    return priority == 3
        ? Colors.green
        : priority == 2
            ? Colors.orange
            : Colors.red;
  }

  void navigateToDetails(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));
    if (result == true) getData();
  }
}
