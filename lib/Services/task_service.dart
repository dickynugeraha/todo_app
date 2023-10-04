import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_apps/Models/Task.dart';
import 'package:todo_apps/Services/constant.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return _tasks;
  }

  Task getById(String id) {
    return _tasks.firstWhere((element) => element.id == id);
  }

  Future<void> addTask({
    required String projectId,
    required String title,
    required String priority,
    required String deadline,
    required bool isCompleted,
  }) async {
    try {
      var response = await Dio().post(
        "${Constant.url}/tasks.json",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "projectId": projectId,
          "title": title,
          "priority": priority,
          "deadline": deadline,
          "isCompleted": isCompleted,
        },
      );
      final taskId = (response.data)["name"];

      final newTask = Task(
        id: taskId,
        projectId: projectId,
        title: title,
        priority: priority,
        deadline: deadline,
        isCompleted: isCompleted,
      );

      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTask({
    required String taskId,
    required String projectId,
    required String title,
    required String priority,
    required String deadline,
    required bool isCompleted,
  }) async {
    final taskIndex = _tasks.indexWhere((element) => element.id == taskId);
    final taskEdited = Task(
      id: _tasks[taskIndex].id,
      projectId: _tasks[taskIndex].projectId,
      title: title,
      priority: priority,
      deadline: deadline,
      isCompleted: isCompleted,
    );
    _tasks[taskIndex] = taskEdited;
    notifyListeners();

    try {
      await Dio().patch(
        "${Constant.url}/tasks/$taskId.json",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "projectId": projectId,
          "title": title,
          "priority": priority,
          "deadline": deadline,
          "isCompleted": isCompleted,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getTasks() async {
    try {
      var response = await Dio().get("${Constant.url}/tasks.json");
      final extractedData = response.data as Map<String, dynamic>;
      if (extractedData == null) return;

      List<Task> taskLoaded = [];

      extractedData.forEach((key, value) {
        taskLoaded.add(
          Task(
            id: key,
            projectId: value["projectId"],
            title: value["title"],
            priority: value["priority"],
            deadline: value["deadline"],
            isCompleted: value["isCompleted"],
          ),
        );
      });
      _tasks = taskLoaded;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completedUncompletedTask(String taskId, bool isConpleted) async {
    try {
      final taskIndex = _tasks.indexWhere((rask) => rask.id == taskId);

      notifyListeners();

      await Dio().patch(
        "${Constant.url}/tasks/$taskId.json",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: {
          "isCompleted": isConpleted,
        },
      );

      final newTask = Task(
        id: _tasks[taskIndex].id,
        title: _tasks[taskIndex].title,
        deadline: _tasks[taskIndex].deadline,
        priority: _tasks[taskIndex].priority,
        projectId: _tasks[taskIndex].projectId,
        isCompleted: isConpleted,
      );

      _tasks[taskIndex] = newTask;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final taskIndex = _tasks.indexWhere((rask) => rask.id == taskId);
      _tasks.removeAt(taskIndex);

      notifyListeners();

      await Dio().delete(
        "${Constant.url}/tasks/$taskId.json",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}
