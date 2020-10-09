import 'package:flutter/material.dart';
import 'package:TodoApp/model/todo.dart';
import 'package:TodoApp/utils/dbhelper.dart';
import 'package:intl/intl.dart';

final List<String> choices = const <String>['Save', 'Delete', 'Back'];

DbHelper dbHelper = DbHelper();
const menuSave = 'Save';
const menuDelete = 'Delete';
const menuBack = 'Back';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ['High', 'Medium', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double formGap = 15.0;
  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    // ignore: deprecated_member_use
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return choices
                  .map((String e) => PopupMenuItem(value: e, child: Text(e)))
                  .toList();
            },
            onSelected: select,
          )
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(formGap),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) => this.updateTitle(),
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(formGap),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) => updateDescription(),
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              ListTile(
                  title: Padding(
                padding: EdgeInsets.all(formGap),
                child: DropdownButton<String>(
                    items: _priorities
                        .map((String priority) => DropdownMenuItem(
                            child: Text(priority), value: priority))
                        .toList(),
                    value: retrievePriority(todo.priority),
                    onChanged: (String value) {
                      updatePriority(value);
                    }),
              )),
              ListTile(
                  title: Padding(
                      padding: EdgeInsets.only(bottom: formGap),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                              child: Text('Save',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.blueAccent,
                              onPressed: () => save()),
                          RaisedButton(
                              child: Text('Cancel',
                                  style: TextStyle(color: Colors.black)),
                              onPressed: () => Navigator.pop(context, true)),
                        ],
                      ))),
            ],
          )
        ],
      ),
    );
  }

  void select(String value) async {
    int result;
    switch (value) {
      case menuSave:
        save();
        break;
      case menuDelete:
        debugPrint(todo.id.toString());
        if (todo.id == null) {
          return;
        }
        result = await dbHelper.deleteTodo(todo.id);
        if (result != 0) {
          Navigator.pop(context, true);
          AlertDialog alertDialog = AlertDialog(
              title: Text('Delete Todo'),
              content: Text('The todo has been deleted'));
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void save() {
    todo.date = DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      dbHelper.updateTodo(todo);
    } else {
      dbHelper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {});
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}
