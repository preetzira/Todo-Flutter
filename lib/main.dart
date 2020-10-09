import 'package:flutter/material.dart';
// import 'package:TodoApp/utils/dbhelper.dart';
// import 'package:TodoApp/model/todo.dart';
import 'package:TodoApp/screens/todoList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // List<Todo> todos = List<Todo>();
  @override
  Widget build(BuildContext context) {
    // DbHelper helper = DbHelper();
    // helper
    //     .initializeDb()
    //     .then((result) => helper.getTodos().then((value) => todos = value));
    // DateTime today = DateTime.now();
    // Todo todo = Todo("Buy Food", 2, today.toString(), "Specially Milk");
    // var result = helper.insertTodo(todo);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: TodoList());
  }
}
