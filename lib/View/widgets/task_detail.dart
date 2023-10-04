// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Services/task_service.dart';
import 'package:todo_apps/View/screens/task_new_screen.dart';
import 'package:todo_apps/View/widgets/global_widget.dart';

class TaskDetail extends StatelessWidget {
  final String id;
  const TaskDetail({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context);
    final task = tasks.getById(id);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Detail Task",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 67, 67, 67),
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () async {
                    await tasks.completedUncompletedTask(id, !task.isCompleted);
                  },
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank_rounded,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Title : ",
                  style: TextStyle(color: Colors.grey),
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Priority : ",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  task.priority,
                  style: TextStyle(
                    color: task.priority == "Low"
                        ? Colors.red
                        : task.priority == "High"
                            ? Colors.green
                            : task.priority == 'Mid'
                                ? Colors.yellow
                                : Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Deadline : ",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  task.deadline,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NewTaskScreen(
                          taskId: task.id,
                          projectId: task.projectId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),
                TextButton.icon(
                  onPressed: () async {
                    try {
                      await tasks.deleteTask(id);
                      GlobalWidget.customAwesomeDialog(
                        context: context,
                        title: "Successfully",
                        desc: "Task deleted!",
                        dialogSuccess: true,
                        isPop: true,
                      );
                    } catch (e) {
                      GlobalWidget.customAwesomeDialog(
                        context: context,
                        title: "Error occured",
                        desc: "Failed delete task!",
                        dialogSuccess: false,
                        isPop: true,
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
