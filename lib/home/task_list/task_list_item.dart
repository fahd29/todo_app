import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/provider/app_theme_provider.dart';
import 'package:todo_app/provider/auth_user_provider.dart';
import 'package:todo_app/provider/list_provider.dart';

import '../../model/task.dart';

class TaskListItem extends StatefulWidget {
  Task task;

  TaskListItem({required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    var providerTheme = Provider.of<AppThemeProvider>(context);
    String? uId = authProvider.currentUser!.id;
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.25,
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                FireBaseUtils.deleteTaskFromFireStore(
                        widget.task, authProvider.currentUser!.id!)
                    .then((value) {
                  print("task deleted sucessfully");
                  listProvider
                      .getAllTasksFromFirestore(authProvider.currentUser!.id!);
                }).timeout(Duration(seconds: 1), onTimeout: () {
                  print("task deleted sucessfully");
                  listProvider
                      .getAllTasksFromFirestore(authProvider.currentUser!.id!);
                });
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: providerTheme.isDarkMode()
                ? AppColors.blackDarkColor
                : AppColors.whiteColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                color: widget.task.isDone == true
                    ? AppColors.greenColor
                    : AppColors.primaryColor,
                height: MediaQuery.of(context).size.height * 0.09,
                width: 4,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: widget.task.isDone == true
                            ? AppColors.greenColor
                            : AppColors.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(widget.task.description,
                      style: Theme.of(context).textTheme.titleMedium)
                ],
              )),
              InkWell(
                onTap: () {
                  widget.task.isDone = !widget.task.isDone;
                  FireBaseUtils.editIsDone(uId: uId!, task: widget.task);
                  setState(() {});
                },
                child: widget.task.isDone == true
                    ? Text(
                        "Done!!",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: widget.task.isDone == true
                                ? AppColors.greenColor
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w500),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.01,
                          horizontal: width * 0.05,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.primaryColor,
                        ),
                        child: Icon(
                          Icons.check,
                          color: AppColors.whiteColor,
                          size: 35,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
