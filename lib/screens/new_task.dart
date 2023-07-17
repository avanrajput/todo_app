import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_task.dart';
import 'package:todo_app/widgets/chip.dart';
import 'package:todo_app/widgets/select_date.dart';
import 'package:todo_app/widgets/time_select.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key, required this.onAddTask});

  final void Function(TodoTask task) onAddTask;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _formKey = GlobalKey<FormState>();
  var _enteredTitle = '';
  Category _enteredCategory = Category.call;
  var _enteredDate = '';
  var _enteredStartTime = '';
  var _enteredEndTime = '';
  var _enteredDescription = '';

  void _saveCategory(Category category) {
    _enteredCategory = category;
  }

  void _saveDate(String date) {
    _enteredDate = date;
  }

  void _saveTime(String startTime, String endTime) {
    _enteredStartTime = startTime;
    _enteredEndTime = endTime;
  }

  void _saveTask() {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        var newTask = TodoTask(
          title: _enteredTitle,
          category: _enteredCategory,
          date: _enteredDate,
          startTime: _enteredStartTime,
          endTime: _enteredEndTime,
          description: _enteredDescription,
        );
        widget.onAddTask(newTask);
        Navigator.of(context).pop();
      }
    } catch (errror) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Some Error occured while saving Task')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create New Task",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  maxLength: 25,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                      labelText: "Task Name",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 16)),
                  onSaved: (value) {
                    _enteredTitle = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'Invalid value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  "Select Category",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                SelectCategory(onSaveCategory: _saveCategory),
                const SizedBox(height: 10),
                SelectDate(onSaveDate: _saveDate),
                const SizedBox(height: 10),
                SelectTime(onSaveTime: _saveTime),
                const SizedBox(height: 10),
                TextFormField(
                  maxLength: 50,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.blue, fontSize: 16)),
                  onSaved: (value) {
                    _enteredDescription = value!;
                  },
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'Invalid value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(maxwidth - 110, 50),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      "Create Task",
                      style: TextStyle(color: Colors.white),
                    ),
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
