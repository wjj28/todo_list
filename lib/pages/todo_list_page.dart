import 'package:flutter/material.dart';
import 'package:todo_list/repositories/todo_repository.dart';

import '../models/todo.dart';
import '../widgets/completed_todo_list_item.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];
  List<Todo> completed = [];

  Todo? deletedTodo;
  int? deletedTodoPos;
  Todo? completedTodo;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  String? errorText;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Adding new tasks
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: todoController,
                      decoration: InputDecoration(
                        labelText: 'What are the ToDos for today?',
                        // hintText: 'Read a book..',
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlueAccent)),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.lightBlueAccent)),
                        errorText: errorText,
                      ),
                      // onSubmitted: onSubmitted,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: newTodo,
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      primary: Colors.lightBlueAccent,
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),

              // new task
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Todo todo in todos)
                      TodoListItem(
                        todo: todo,
                        onDelete: onDelete,
                        onComplete: onComplete,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Bottom widget
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'You have ${todos.length} pending tasks',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showDeleteAllConfirmationDialog();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.lightBlueAccent,
                      // fixedSize: const Size(10,55)
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 13),
                    ),
                    child: const Text('Clear all'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Completed todos
      Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Completed ToDos',
                  style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                // new task
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in completed)
                        CompletedTodoListItem(
                          todo: todo,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Bottom widget
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Completed tasks: ${completed.length}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showDeleteAllCompletedConfirmationDialog();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlueAccent,
                        // fixedSize: const Size(10,55)
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 13),
                      ),
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ];

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            title: const Text(' 📃 Cami\'s ToDo list '),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.lightBlueAccent,
              unselectedItemColor: Colors.white.withOpacity(0.7),
              selectedItemColor: Colors.white,
              currentIndex: selectedIndex,
              onTap: (index) => setState(() {
                    selectedIndex = index;
                  }),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.fact_check_outlined,
                    size: 28,
                  ),
                  label: 'Todos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.done,
                    size: 28,
                  ),
                  label: 'Completed',
                ),
              ]),
          body: tabs[selectedIndex]),
    );
  }

  void newTodo() {
    String task = todoController.text;

    if (task.isEmpty) {
      setState(() {
        errorText = 'It cannot be empty';
      });
      return;
    }
    setState(() {
      Todo newTodo = Todo(title: task, dateTime: DateTime.now());
      todos.add(newTodo);
    });
    todoController.clear();
    todoRepository.saveTodoList(todos);
    errorText = null;
  }

  void onComplete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      completed.add(todo);
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task ${todo.title} was completed! Well done!',
        ),
        action: SnackBarAction(
          label: 'Oops, not done? ',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
      completed.remove(todo);
    });
    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Task ${todo.title} was deleted!',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Delete all from todos
  void showDeleteAllConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all?'),
        content: const Text('You are about to delete all the todos'),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
  }

  void showDeleteAllCompletedConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all?'),
        content: const Text('You are about to delete all the completed todos'),
        actions: [
          //cancel
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              primary: Colors.blue,
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllCompletedTodos();
            },
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

  void deleteAllCompletedTodos() {
    setState(() {
      completed.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
