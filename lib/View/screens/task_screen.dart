// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Models/Task.dart';
import 'package:todo_apps/Services/task_service.dart';
import 'package:todo_apps/View/widgets/main_drawer.dart';
import 'package:todo_apps/View/widgets/task_filter_drawer.dart';
import 'package:todo_apps/View/widgets/task_item.dart';
import 'package:todo_apps/View/widgets/task_list_widget.dart';

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

  Map<String, dynamic> _filters = {
    "isAll": true,
    "isCompleted": false,
    "isUncompleted": false,
    "priority": "All",
    "deadline": "",
  };

  void taskFilterHandler(Map<String, dynamic> filterData) {
    setState(() {
      _filters = filterData;
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskProvider>(context);
    List<Task> tasks = task.tasks;

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
      endDrawer: TaskFilterDrawer(
        currentFilter: _filters,
        onFilter: taskFilterHandler,
      ),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            )
          : TaskList(filtered: _filters),
    );
  }
}
