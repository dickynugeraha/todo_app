// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../Services/project_service.dart';
import '../../View/widgets/global_widget.dart';

class AddProject extends StatefulWidget {
  final bool isAdd;
  final String id;

  const AddProject({
    Key? key,
    required this.isAdd,
    required this.id,
  }) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  var _isLoading = false;
  var _isInit = true;
  late String title = widget.isAdd ? "Add" : "Edit";
  Map<String, String> initValue = {"title": "", "desc": ""};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if ((widget.id).isNotEmpty) {
        final project =
            Provider.of<ProjectProvider>(context).getProjectById(widget.id);

        initValue = {"title": project.title, "desc": project.desc};
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addProjectHadnler() async {
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        widget.isAdd
            ? await Provider.of<ProjectProvider>(context, listen: false)
                .addProject(
                title: initValue["title"]!,
                desc: initValue["desc"]!,
              )
            : await Provider.of<ProjectProvider>(context, listen: false)
                .editProject(
                projectId: widget.id,
                title: initValue["title"]!,
                desc: initValue["desc"]!,
              );
        GlobalWidget.customAwesomeDialog(
          context: context,
          title: "Success",
          desc: "$title project successfully",
          dialogSuccess: true,
          isPop: true,
        );
      } catch (e) {
        GlobalWidget.customAwesomeDialog(
          context: context,
          title: "Error occured",
          desc: "$title project failed, ${e.toString()}",
          dialogSuccess: false,
          isPop: true,
        );
      }

      setState(() {
        _isLoading = false;
      });
    }

    return SingleChildScrollView(
      child: Container(
        height: 320,
        padding: const EdgeInsets.all(10.0),
        child: _isLoading
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$title project!",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.blue),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        initialValue: initValue["title"],
                        decoration: GlobalWidget.customInputDecoration("Title"),
                        onSaved: (newValue) {
                          initValue["title"] = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Title must be entered";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: initValue["desc"],
                        decoration:
                            GlobalWidget.customInputDecoration("Description"),
                        onSaved: (newValue) {
                          initValue["desc"] = newValue!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Description must be entered";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: GlobalWidget.buttonPrimary(
                          title: "Submit",
                          onTapButton: addProjectHadnler,
                          isActive: true,
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
