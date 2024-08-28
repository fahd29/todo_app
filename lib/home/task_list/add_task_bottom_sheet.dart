import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/app_theme_provider.dart';
import 'package:todo_app/provider/auth_user_provider.dart';
import 'package:todo_app/provider/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var ProviderTheme = Provider.of<AppThemeProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            "Add New Task",
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.whiteColor),
          ),
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Task Title';
                      }

                      return null;
                    },
                    onChanged: (text) {
                      title = text;
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Task Title',
                        hintStyle: TextStyle(
                            color: ProviderTheme.isDarkMode()
                                ? AppColors.whiteColor
                                : AppColors.blackDarkColor)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Task Description';
                      }
                      {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Enter Task Descripation',
                        hintStyle: TextStyle(
                            color: ProviderTheme.isDarkMode()
                                ? AppColors.whiteColor
                                : AppColors.blackDarkColor)),
                    onChanged: (text) {
                      description = text;
                    },
                    maxLines: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select Date',
                      //textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: ProviderTheme.isDarkMode()
                              ? AppColors.whiteColor
                              : AppColors.blackDarkColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showCalender();
                      },
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/'
                        '${selectedDate.year}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ProviderTheme.isDarkMode()
                                ? AppColors.whiteColor
                                : AppColors.blackDarkColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        'Add',
                        style: Theme.of(context).textTheme.titleLarge,
                      ))
                ],
              ))
        ],
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Task task =
          Task(title: title, description: description, dateTime: selectedDate);

      var authProvider = Provider.of<AuthUserProvider>(context, listen: false);
      FireBaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!)
          .then((value) {
        print('task added sucessfully');
        listProvider.getAllTasksFromFirestore(authProvider.currentUser!.id!);

        Navigator.pop(context);
      }).timeout(Duration(seconds: 1), onTimeout: () {
        print('task added sucessfully');
        listProvider.getAllTasksFromFirestore(authProvider.currentUser!.id!);

        Navigator.pop(context);
      });
    }
  }

  void showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    selectedDate = chosenDate ?? selectedDate;
    setState(() {});
  }
}
