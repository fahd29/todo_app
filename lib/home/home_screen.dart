import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/home/settings/settings_tab.dart';
import 'package:todo_app/home/task_list/add_task_bottom_sheet.dart';
import 'package:todo_app/home/task_list/task_list_tab.dart';
import 'package:todo_app/provider/app_theme_provider.dart';
import 'package:todo_app/provider/list_provider.dart';

import '../provider/auth_user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int SelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    var providerTheme = Provider.of<AppThemeProvider>(context);
    return Stack(children: [
      providerTheme.isDarkMode()
          ? Image.asset(
              'assets/images/main_background_dark.png',
            )
          : Image.asset(
              'assets/images/main_background_light.png',
            ),
      Scaffold(
        appBar: AppBar(
        title: Text("To Do List{${authProvider.currentUser!.name!}}",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: providerTheme.isDarkMode()
                      ? AppColors.blackDarkColor
                      : AppColors.whiteColor)),
          actions: [
            IconButton(
                onPressed: () {
                  listProvider.tasksList = [];
                  authProvider.currentUser = null;
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                icon: Icon(Icons.logout))
          ],
        ),
      bottomNavigationBar: BottomAppBar(
          color: providerTheme.isDarkMode()
              ? AppColors.blackDarkColor
              : AppColors.whiteColor,
          shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: BottomNavigationBar(
          currentIndex: SelectedIndex,
          onTap: (index) {
            SelectedIndex = index;
            setState(() {});
          },
          items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Task List'),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'settings'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskBottomSheet();
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            width: double.infinity,
            height: 80,
          ),
          Expanded(child: SelectedIndex == 0 ? TaskListTab() : SettingsTab())
        ],
      ),
      )
    ]);
  }

  void addTaskBottomSheet() {
    var providerTheme = Provider.of<AppThemeProvider>(context, listen: false);
    showModalBottomSheet(
        backgroundColor: providerTheme.isDarkMode()
            ? AppColors.blackDarkColor
            : AppColors.whiteColor,
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}
