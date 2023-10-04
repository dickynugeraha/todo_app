// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Services/project_service.dart';
import 'package:todo_apps/View/screens/task_new_screen.dart';

class ProjectDetail extends StatelessWidget {
  final String id;

  const ProjectDetail({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projects = Provider.of<ProjectProvider>(context);
    final project = projects.getProjectById(id);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Detail project",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 67, 67, 67),
                ),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () async {
                  await projects.archivedUnarchivedProject(
                      id, !project.isArchived);
                },
                child: Icon(
                  project.isArchived
                      ? Icons.bookmark
                      : Icons.bookmark_add_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                "Title : ",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                project.title,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Description : ",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                project.desc,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Tasks : ",
                style: TextStyle(color: Colors.grey),
              ),
              project.tasks.isEmpty
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => NewTaskScreen(
                              projectId: id,
                              taskId: "",
                            ),
                          ),
                        );
                      },
                      child: Text("Add new task"),
                    )
                  : ListView.builder(
                      itemCount: project.tasks.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = project.tasks[index];

                        return Text("$index). $item");
                      },
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
