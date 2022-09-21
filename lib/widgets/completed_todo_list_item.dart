import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class CompletedTodoListItem extends StatefulWidget {
  const CompletedTodoListItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  final Todo todo;

  @override
  State<CompletedTodoListItem> createState() => _CompletedTodoListItemState();
}

class _CompletedTodoListItemState extends State<CompletedTodoListItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),

        child: Column(
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
    );
  }
}
