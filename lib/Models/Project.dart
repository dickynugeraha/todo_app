import 'package:todo_apps/Models/Task.dart';

class Project {
  final String id;
  final String title;
  final String desc;
  final bool isArchived;
  List<Task> tasks;

  Project({
    required this.id,
    required this.title,
    required this.desc,
    required this.isArchived,
    required this.tasks,
  });
}
