
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const todoList = 'todo_list';

class TodoRepository{
  TodoRepository(){
    SharedPreferences.getInstance();
  }

  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo>todos){
    final jsonString = json.encode(todos);
    
    sharedPreferences.setString(todoList, jsonString);

  }

}