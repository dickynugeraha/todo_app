// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:todo_apps/Models/Project.dart';
import 'package:todo_apps/View/widgets/global_widget.dart';
import 'package:todo_apps/View/widgets/main_drawer.dart';
import 'dart:math';

import '../widgets/project_list_widget.dart';
import '../../Services/project_service.dart';
import '../widgets/project_add_widget.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  var isInit = true;
  var isLoading = true;
  int filtered = 5;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<ProjectProvider>(context)
          .getProjects()
          .then((value) => isLoading = false);

      isInit = false;
    }
    super.didChangeDependencies();
  }

  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Projects",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          elevation: 5,
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return const [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Archived"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Unarchived"),
                ),
              ];
            }, onSelected: (value) {
              setState(() {
                filtered = value;
              });
            }),
          ],
        ),
        drawer: const MainDrawer(),
        body: isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Projects",
                      //       style: Theme.of(context).textTheme.headlineLarge,
                      //     ),
                      //     PopupMenuButton(itemBuilder: (context) {
                      //       return const [
                      //         PopupMenuItem<int>(
                      //           value: 0,
                      //           child: Text("Archived"),
                      //         ),
                      //         PopupMenuItem<int>(
                      //           value: 1,
                      //           child: Text("Unarchived"),
                      //         ),
                      //       ];
                      //     }, onSelected: (value) {
                      //       setState(() {
                      //         filtered = value;
                      //       });
                      //     }),
                      //   ],
                      // ),
                      // const SizedBox(height: 18),
                      ProjectList(filtered: filtered)
                    ],
                  ),
                ),
              ),
        floatingActionButton: isLoading
            ? const SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          left: 12,
                          right: 12,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: const AddProject(isAdd: true, id: ""),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
      ),
    );
  }
}
