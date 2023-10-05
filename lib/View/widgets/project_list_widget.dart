// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Models/Project.dart';
import 'package:todo_apps/View/widgets/project_add_widget.dart';
import 'package:todo_apps/View/widgets/project_detail_widget.dart';

import '../../Services/project_service.dart';
import './project_item_widget.dart';

class ProjectList extends StatelessWidget {
  final int filtered;
  const ProjectList({
    Key? key,
    required this.filtered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final projects = Provider.of<ProjectProvider>(context);
    List<Project> items = projects.projectsUnarchived;
    switch (filtered) {
      case 0:
        items = projects.projectsArchived;
        break;
      case 1:
        items = projects.projectsUnarchived;
        break;
      default:
        items = projects.projectsUnarchived;
    }

    return SizedBox(
      height: deviceSize.height * 0.82,
      child: items.isEmpty
          ? const Center(
              child: Text("Project not found!"),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: items
                    .map(
                      (e) => ProjectItem(
                        id: e.id,
                        title: e.title,
                        subtitle: e.desc,
                        onDeleteProject: (String id) async {
                          await Provider.of<ProjectProvider>(
                            context,
                            listen: false,
                          ).deleteProject(id);
                        },
                        onDetailProject: (String id) async {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: ProjectDetail(id: id),
                            ),
                          );
                        },
                        onEditProject: (String id) {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 12,
                                  left: 12,
                                  right: 12,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: AddProject(isAdd: false, id: id),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
