import 'package:flutter/material.dart';
import 'package:todo_apps/View/screens/project_screen.dart';
import 'package:todo_apps/View/screens/task_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget navItem(IconData icon, String title, Widget screen) {
      return ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => screen,
        )),
      );
    }

    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  "https://cdn-icons-png.flaticon.com/512/2098/2098402.png",
                  width: 60,
                ),
                const SizedBox(width: 6),
                const Text(
                  "Menu",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            child: Column(
              children: [
                navItem(
                  Icons.laptop_chromebook,
                  "Project",
                  const ProjectsScreen(),
                ),
                const Divider(),
                navItem(
                  Icons.list_alt,
                  "Task",
                  const TaskScreen(),
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
