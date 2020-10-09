class Todo {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  Todo(this._title, this._priority, this._date, [this._description]);
  Todo.update(this._id, this._title, this._priority, this._date,
      [this._description]);
  int get id => _id;
  String get title => _title;
  String get date => _date;
  String get description => _description;
  int get priority => _priority;

  set title(String value) {
    if (value.length <= 255) {
      _title = value;
    }
  }

  set description(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  set priority(int value) {
    if (value > 0 && value <= 3) {
      _priority = value;
    }
  }

  set date(String value) {
    if (value != null) {
      _date = value;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["priority"] = _priority;
    map["date"] = _date;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Todo.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._priority = o["priority"];
    this._date = o["date"];
  }
}
