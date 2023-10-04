import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../Models/Task.dart';
import './constant.dart';
import '../Models/Project.dart';
import 'dart:convert';

class ProjectProvider with ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects {
    return _projects;
  }

  List<Project> get projectsAscending {
    return _projects.sort() as List<Project>;
  }

  List<Project> get projectsDescending {
    return _projects.sort(
      (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
    ) as List<Project>;
  }

  List<Project> get projectsArchived {
    return _projects.where((project) => project.isArchived == true).toList();
  }

  List<Project> get projectsUnarchived {
    return _projects.where((project) => project.isArchived == false).toList();
  }

  Project getProjectById(String projectId) {
    return _projects.firstWhere((project) => project.id == projectId);
  }

  Future<void> archivedUnarchivedProject(
      String projectId, bool isArchived) async {
    try {
      final indexProject =
          _projects.indexWhere((element) => element.id == projectId);
      await Dio().patch(
        "${Constant.url}/projects/$projectId.json",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: json.encode({
          "isArchived": isArchived,
        }),
      );

      final newProject = Project(
        id: _projects[indexProject].id,
        title: _projects[indexProject].title,
        desc: _projects[indexProject].desc,
        isArchived: isArchived,
        tasks: _projects[indexProject].tasks,
      );

      _projects[indexProject] = newProject;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getProjects() async {
    try {
      final response = await Dio().get("${Constant.url}/projects.json");

      final extractedData = response.data as Map<String, dynamic>;
      if (extractedData == null) return;

      List<Project> projectsLoaded = [];

      extractedData.forEach(
        (projectId, project) {
          projectsLoaded.add(
            Project(
              id: projectId,
              title: project["title"],
              desc: project["desc"],
              isArchived: project["isArchived"],
              tasks: project["tasks"] == null
                  ? []
                  : (project["tasks"] as List<dynamic>)
                      .map(
                        (e) => Task(
                          id: e["id"],
                          projectId: e["projectId"],
                          title: e["title"],
                          priority: e["priority"],
                          deadline: e["deadline"],
                          isCompleted: e["status"],
                        ),
                      )
                      .toList(),
            ),
          );
        },
      );
      _projects = projectsLoaded;
      notifyListeners();
    } on DioException catch (e) {
      throw Exception('Failed Get Data $e');
    }
  }

  Future<void> addProject({
    required String title,
    required String desc,
  }) async {
    try {
      final response = await Dio().post(
        "${Constant.url}/projects.json",
        options: Options(contentType: "application/json"),
        data: json.encode(
          {
            "title": title,
            "desc": desc,
            "isArchived": false,
            "tasks": [],
          },
        ),
      );

      var newProject = Project(
        id: (response.data)["name"],
        title: title,
        desc: desc,
        isArchived: false,
        tasks: [],
      );

      _projects.add(newProject);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editProject({
    required String projectId,
    required String title,
    required String desc,
  }) async {
    try {
      final indexProject =
          _projects.indexWhere((project) => project.id == projectId);

      final newProject = Project(
        id: _projects[indexProject].id,
        title: title,
        desc: desc,
        isArchived: _projects[indexProject].isArchived,
        tasks: _projects[indexProject].tasks,
      );

      _projects[indexProject] = newProject;
      notifyListeners();

      await Dio().put(
        "${Constant.url}/projects/$projectId.json",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: json.encode({
          "title": title,
          "desc": desc,
          "isArchived": _projects[indexProject].isArchived,
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      final indexProjects =
          _projects.indexWhere((project) => project.id == projectId);
      _projects.removeAt(indexProjects);

      notifyListeners();

      await Dio().delete(
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        "${Constant.url}/projects/$projectId.json",
      );
    } catch (e) {
      rethrow;
    }
  }
}
