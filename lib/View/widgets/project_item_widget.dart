// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, prefer_function_declarations_over_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:math';

final random = Random();

class ProjectItem extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final Function(String) onDeleteProject;
  final Function(String) onDetailProject;
  final Function(String) onEditProject;

  const ProjectItem({
    Key? key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.onDeleteProject,
    required this.onDetailProject,
    required this.onEditProject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        onDeleteProject(id);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project was deleted'),
          ),
        );
      },
      key: Key(title),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.red,
        padding: const EdgeInsets.all(12),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete,
              size: 24,
              color: Colors.white,
            )
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Colors.grey,
                offset: Offset(0, 3),
              )
            ]),
        child: ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    onEditProject(id);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Color.fromRGBO(
                      random.nextInt(255),
                      random.nextInt(255),
                      random.nextInt(255),
                      1,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    onDetailProject(id);
                  },
                  child: Icon(
                    Icons.info,
                    color: Color.fromRGBO(
                      random.nextInt(255),
                      random.nextInt(255),
                      random.nextInt(255),
                      1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
