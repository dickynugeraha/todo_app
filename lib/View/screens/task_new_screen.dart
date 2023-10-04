import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Services/task_service.dart';

import 'package:todo_apps/View/widgets/global_widget.dart';
import 'package:todo_apps/View/widgets/task_item.dart';

class NewTaskScreen extends StatefulWidget {
  final String taskId;
  final String projectId;
  const NewTaskScreen({
    Key? key,
    required this.taskId,
    required this.projectId,
  }) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final formKey = GlobalKey<FormState>();

  var _isInit = true;
  bool isLoading = false;
  var completedTask = true;

  Map<String, dynamic> initialvalue = {
    "title": "",
    "priority": "Null",
    "deadline": "",
  };

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.taskId.isNotEmpty) {
        final task = Provider.of<TaskProvider>(context, listen: false)
            .getById(widget.taskId);
        initialvalue = {
          "title": task.title,
          "priority": task.priority,
          "deadline": task.deadline,
        };
        completedTask = task.isCompleted;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> addTaskHandler() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      widget.taskId.isEmpty
          ? await Provider.of<TaskProvider>(context, listen: false).addTask(
              projectId: widget.projectId,
              title: initialvalue["title"],
              priority: initialvalue["priority"],
              deadline: initialvalue["deadline"],
              isCompleted: completedTask,
            )
          : await Provider.of<TaskProvider>(context, listen: false).editTask(
              taskId: widget.taskId,
              projectId: widget.projectId,
              title: initialvalue["title"],
              priority: initialvalue["priority"],
              deadline: initialvalue["deadline"],
              isCompleted: completedTask,
            );

      GlobalWidget.customAwesomeDialog(
        context: context,
        title: "Successfully",
        desc: widget.taskId.isEmpty
            ? 'Task successfully added!'
            : 'Task successfully edited!',
        dialogSuccess: true,
        isPop: false,
      );
    } catch (e) {
      GlobalWidget.customAwesomeDialog(
        context: context,
        title: "Error Occured",
        desc: widget.taskId.isEmpty
            ? 'Task failed added!, $e'
            : 'Task failed edited!, $e',
        dialogSuccess: false,
        isPop: false,
      );
    }

    setState(() {
      isLoading = false;

      initialvalue = {
        "title": "",
        "priority": "Null",
        "deadline": "",
        "status": "",
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId.isEmpty ? "Add new task" : "Edit task"),
        actions: [
          IconButton(onPressed: addTaskHandler, icon: const Icon(Icons.save))
        ],
      ),
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: initialvalue["title"],
                          decoration:
                              GlobalWidget.customInputDecoration("Title"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Title must be entered";
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            initialvalue["title"] = newValue!;
                          },
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(pickedDate);
                                  setState(() {
                                    initialvalue["deadline"] = formattedDate;
                                  });
                                }
                              },
                              icon: const Icon(Icons.date_range),
                              label: const Text("Deadline"),
                            ),
                            Container(
                              width: 130,
                              child: DropdownButton(
                                isExpanded: true,
                                value: initialvalue["priority"],
                                items: const [
                                  DropdownMenuItem(
                                    value: "Null",
                                    child: Text("Priority"),
                                  ),
                                  DropdownMenuItem(
                                    value: "High",
                                    child: Text("High"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Mid",
                                    child: Text("Mid"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Low",
                                    child: Text("Low"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    initialvalue["priority"] = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GlobalWidget.buttonPrimary(
                              title: "Completed",
                              onTapButton: () {
                                setState(() {
                                  completedTask = !completedTask;
                                });
                              },
                              isActive: completedTask,
                            ),
                            GlobalWidget.buttonPrimary(
                              title: "Incompleted",
                              onTapButton: () {
                                setState(() {
                                  completedTask = !completedTask;
                                });
                              },
                              isActive: !completedTask,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
