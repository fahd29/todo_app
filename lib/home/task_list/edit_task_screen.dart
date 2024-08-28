import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/app_theme_provider.dart';
import 'package:todo_app/provider/auth_user_provider.dart';
import 'package:todo_app/provider/list_provider.dart';

class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({super.key});

  static const String routeName = "edit_task";

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  var formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  late ListProvider listProvider;
  late Task taskModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      taskModel = ModalRoute.of(context)!.settings.arguments as Task;
      titleController.text = taskModel.title ?? '';
      descriptionController.text = taskModel.description ?? '';
      selectedDate = taskModel.dateTime!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var providerTheme = Provider.of<AppThemeProvider>(context);
    var sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: providerTheme.isDarkMode()
          ? AppColors.blackDarkColor
          : AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("To Do List",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: providerTheme.isDarkMode()
                    ? AppColors.blackDarkColor
                    : AppColors.whiteColor)),
      ),
      body: Stack(
        children: [
          Container(
            height: sizeScreen.height * 0.1,
            color: AppColors.primaryColor,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green, width: 3),
              color: providerTheme.isDarkMode()
                  ? AppColors.blackDarkColor
                  : AppColors.whiteColor,
            ),
            height: sizeScreen.height * 0.75,
            margin: EdgeInsets.symmetric(
                vertical: sizeScreen.height * 0.04,
                horizontal: sizeScreen.width * 0.1),
            child: Column(
              children: [
                Text(
                  "Edit Task",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: providerTheme.isDarkMode()
                          ? AppColors.whiteColor
                          : AppColors.blackDarkColor),
                ),
                SizedBox(
                  height: sizeScreen.height * 0.03,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          style: TextStyle(
                            color: providerTheme.isDarkMode()
                                ? AppColors.whiteColor
                                : AppColors.blackDarkColor,
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Task Title';
                            }

                            return null;
                          },
                          controller: titleController,
                          decoration: InputDecoration(
                              hintText: 'Enter Task Title',
                              hintStyle: TextStyle(
                                  color: providerTheme.isDarkMode()
                                      ? AppColors.whiteColor
                                      : AppColors.blackDarkColor)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: providerTheme.isDarkMode()
                                ? AppColors.whiteColor
                                : AppColors.blackDarkColor,
                          ),
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
                                  color: providerTheme.isDarkMode()
                                      ? AppColors.whiteColor
                                      : AppColors.blackDarkColor)),
                          controller: descriptionController,
                          maxLines: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Select Date',
                            //textAlign: TextAlign.start,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: providerTheme.isDarkMode()
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: providerTheme.isDarkMode()
                                          ? AppColors.whiteColor
                                          : AppColors.blackDarkColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sizeScreen.height * 0.18,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              editTask();
                            },
                            child: Text(
                              'Save changes',
                              style: Theme.of(context).textTheme.titleLarge,
                            ))
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void editTask() {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Loading.....');
      taskModel.title = titleController.text;
      taskModel.description = descriptionController.text;
      taskModel.dateTime = selectedDate;

      var authProvider = Provider.of<AuthUserProvider>(context, listen: false);

      FireBaseUtils.editTask(
              uId: authProvider.currentUser!.id!, task: taskModel)
          .then((value) {
        Navigator.of(context).popAndPushNamed(HomeScreen.routeName);
        print('task edited sucessfully');
        listProvider.getAllTasksFromFirestore(authProvider.currentUser!.id!);
        //
        // Navigator.pop(context);
      }).timeout(Duration(seconds: 1), onTimeout: () {
        print('task edited sucessfully');

        listProvider.getAllTasksFromFirestore(authProvider.currentUser!.id!);
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
