// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Models/Task.dart';
import 'package:todo_apps/Services/task_service.dart';
import 'package:todo_apps/View/widgets/task_item.dart';

class TaskList extends StatelessWidget {
  final Map<String, dynamic> filtered;
  const TaskList({Key? key, required this.filtered}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskProvider>(context);
    List<Task> tasks = task.tasks;

    tasks = tasks.where((task) {
      if (filtered["isAll"]) {
        return true;
      } else {
        if (filtered["isCompleted"] && !task.isCompleted) {
          return false;
        }
        if (filtered["isUncompleted"] && task.isCompleted) {
          return false;
        }
        if (filtered["deadline"] != "") {
          if (task.deadline != filtered["deadline"]) {
            return false;
          }
        }
        if (task.priority != filtered["priority"]) {
          return false;
        }
      }
      return true;
    }).toList();

    return GridView(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1.5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: tasks
          .map(
            (e) => TaskItem(
              id: e.id,
              title: e.title,
              isCompleted: e.isCompleted,
            ),
          )
          .toList(),
    );
  }
}
