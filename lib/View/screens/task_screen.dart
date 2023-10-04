// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Models/Task.dart';
import 'package:todo_apps/Services/task_service.dart';
import 'package:todo_apps/View/widgets/main_drawer.dart';
import 'package:todo_apps/View/widgets/task_filter_drawer.dart';
import 'package:todo_apps/View/widgets/task_item.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isInit = true;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<TaskProvider>(context, listen: false).getTasks().then(
            (value) => _isLoading = false,
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskProvider>(context);
    final tasks = task.tasks;

    void taskFilterHandler(String priorityFilter, String deadlineFilter) {
      print(priorityFilter);
      print(deadlineFilter);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),
      drawer: const MainDrawer(),
      endDrawer: TaskFilterDrawer(onFilter: taskFilterHandler),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            )
          : GridView(
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
            ),
    );
  }
}
