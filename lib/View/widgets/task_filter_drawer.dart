import 'package:flutter/material.dart';
import 'package:todo_apps/View/widgets/global_widget.dart';
import 'package:intl/intl.dart';

class TaskFilterDrawer extends StatefulWidget {
  Function onFilter;
  TaskFilterDrawer({Key? key, required this.onFilter}) : super(key: key);

  @override
  State<TaskFilterDrawer> createState() => _TaskFilterDrawerState();
}

class _TaskFilterDrawerState extends State<TaskFilterDrawer> {
  var priorityFilter = "High";
  var deadlineFilter = "";

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Priority",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      width: 80,
                      child: DropdownButton(
                        isExpanded: true,
                        value: priorityFilter,
                        items: const [
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
                          setState(() {
                            priorityFilter = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                TextButton.icon(
                    onPressed: () async {
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
                    icon: const Icon(Icons.date_range),
                    label: const Text("Dedline")),
              ],
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(12)),
              child: Text("Save!"),
              onPressed: () {
                widget.onFilter(priorityFilter, deadlineFilter);
              },
            ),
          ),
        ],
      ),
    );
  }
}
