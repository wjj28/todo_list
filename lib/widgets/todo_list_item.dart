import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
     required this.onDelete,
    required this.onComplete,
  }) : super(key: key);

  final Todo todo;
  final Function onDelete;
  final Function onComplete;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),

          // height: 50,
          // child: Row(
          //   // mainAxisSize: MainAxisSize.min,
          //   children: [
              // Checkbox(
              //   checkColor: Colors.white,
              //   value: isChecked,
              //   shape: const CircleBorder(),
              //   activeColor: Colors.green,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       widget.onComplete(widget.todo);
              //       isChecked = value!;
              //     });
              //   },
              // ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    DateFormat('dd/MM - HH:mm').format(widget.todo.dateTime),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    widget.todo.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          //   ],
          // ),
        ),
        actionExtentRatio: 0.2,
        actionPane: const SlidableBehindActionPane(),
        actions: [
          //Completed task
          IconSlideAction(

            color: Colors.green[900],
            icon: Icons.done_outline,
            caption: 'Completed',
            onTap: () {
              widget.onComplete(widget.todo);
              // completedTodo(context, todo);
            },
          ),
        ],
        secondaryActions: [
          //Delete task
          IconSlideAction(
            color: Colors.red[900],
            icon: Icons.delete,
            caption: 'Delete',
            onTap: () {
              widget.onDelete(widget.todo);
            },
          ),



          // Edit task
          // IconSlideAction(
          //   color: Colors.blue,
          //   icon: Icons.edit,
          //   caption: 'Edit',
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }




}
