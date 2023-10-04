import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskFilterDrawer extends StatefulWidget {
  final Map<String, dynamic> currentFilter;
  final Function onFilter;
  const TaskFilterDrawer({
    Key? key,
    required this.currentFilter,
    required this.onFilter,
  }) : super(key: key);

  @override
  State<TaskFilterDrawer> createState() => _TaskFilterDrawerState();
}

class _TaskFilterDrawerState extends State<TaskFilterDrawer> {
  var priorityFilter = "All";
  var deadlineFilter = "";
  bool isAllFilter = false;
  bool isCompletedFilter = false;
  bool isUncompletedFilter = false;

  @override
  void initState() {
    isAllFilter = widget.currentFilter["isAll"];
    isCompletedFilter = widget.currentFilter["isCompleted"];
    isUncompletedFilter = widget.currentFilter["isUncompleted"];
    deadlineFilter = widget.currentFilter["deadline"];
    priorityFilter = widget.currentFilter["priority"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Text(
                "Filter",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSwitchListTile(
                  title: "Show all task",
                  currentValue: isAllFilter,
                  updateValue: (newValue) {
                    if (isCompletedFilter ||
                        isUncompletedFilter ||
                        priorityFilter != "All" ||
                        deadlineFilter.isNotEmpty) {
                      return;
                    }
                    setState(() {
                      isAllFilter = newValue;
                    });
                  },
                ),
                buildSwitchListTile(
                  title: "Completed task",
                  currentValue: isCompletedFilter,
                  updateValue: (newValue) {
                    if (isAllFilter || isUncompletedFilter) {
                      return;
                    }
                    setState(() {
                      isCompletedFilter = newValue;
                    });
                  },
                ),
                buildSwitchListTile(
                  title: "Uncompleted task",
                  currentValue: isUncompletedFilter,
                  updateValue: (newValue) {
                    if (isAllFilter || isCompletedFilter) {
                      return;
                    }
                    setState(() {
                      isUncompletedFilter = newValue;
                    });
                  },
                ),
                ListTile(
                  leading: Text(
                    "Priority",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  trailing: SizedBox(
                    width: 80,
                    child: DropdownButton(
                      isExpanded: true,
                      value: priorityFilter,
                      items: const [
                        DropdownMenuItem(
                          value: "All",
                          child: Text("All"),
                        ),
                        DropdownMenuItem(
                          value: "High",
                          child: Text("High"),
                        ),
                        DropdownMenuItem(
                          value: "Mid",
                          child: Text("Mid"),
                        ),
                        DropdownMenuItem(
                          value: "Low",
                          child: Text("Low"),
                        ),
                      ],
                      onChanged: (value) {
                        if (isAllFilter) {
                          return;
                        }
                        setState(() {
                          priorityFilter = value!;
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () async {
                        if (isAllFilter) {
                          return;
                        }

                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            deadlineFilter = formattedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.date_range),
                      label: Text(
                        "Dedline",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                        ),
                      )),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(12)),
              child: const Text("Save!"),
              onPressed: () {
                final Map<String, dynamic> filterChoosen = {
                  "isAll": isAllFilter,
                  "isCompleted": isCompletedFilter,
                  "isUncompleted": isUncompletedFilter,
                  "deadline": deadlineFilter,
                  "priority": priorityFilter,
                };
                widget.onFilter(filterChoosen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchListTile({
    required String title,
    required bool currentValue,
    required Function updateValue,
  }) {
    return SwitchListTile(
      activeColor: Theme.of(context).colorScheme.secondary,
      value: currentValue,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
        ),
      ),
      onChanged: (value) {
        updateValue(value);
      },
    );
  }
}
