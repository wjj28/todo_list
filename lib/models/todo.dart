class Todo {
  Todo({
    required this.title,
    required this.dateTime,
    // this.isDone = false,
  });

  String title;
  DateTime dateTime;
  // bool isDone;

Map<String, dynamic> toJson(){
  return {
    'title':title,
    'datetime':dateTime.toIso8601String()
  };
}

}
