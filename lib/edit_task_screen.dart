import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/provider/list_provider.dart';

import 'model/task.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = 'edit_task';
  Task task;

  EditTaskScreen({required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var model = ModalRoute
        .of(context)
        ?.settings
        .arguments as Task;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(
            "To Do List"
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text("Edit Task", style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium,),
                Spacer(),
                TextFormField(
                  initialValue: model.title,
                  onChanged: (value) {
                    model.title = value;
                  },

                  decoration: InputDecoration(
                    labelText: "This is Title",

                  ),
                ),
                Spacer(),
                TextFormField(
                  controller:,
                  initialValue: model.description,
                  onChanged: (value) {
                    model.description = value;
                  },
                  decoration: InputDecoration(
                    labelText: "Task Details",

                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () async {
                    var newDate = await showCalender();
                    if (newDate != null) {
                      model.dateTime = newDate.millisecondsSinceEpoch;
                      setState(() {

                      });
                    }
                  },
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Selected Date",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        ),

                      )),
                ),
                Text('${selectedDate.day}/${selectedDate.month}/'
                    '${selectedDate.year}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Spacer(),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 60
                      ),

                    ),

                    onPressed: () async {
                      await FireBaseUtils.UpdateTask(model); // Correct
                      Navigator.pop(
                          context); // Optionally pop the screen to go back
                    }


                    , child: Text("Save Changes", style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500

                ),
                )
                ),
                Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),


    );
  }

  showCalender() async {
    var chosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
            Duration(days: 365)
        )
    );
    selectedDate = chosenDate ?? selectedDate;
    setState(() {}

    );
    return chosenDate;
  }
}
