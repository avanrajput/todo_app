import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db/database.dart';
import 'package:todo_app/model/todo_task.dart';
import 'package:todo_app/screens/new_task.dart';
import 'package:todo_app/screens/task_details.dart';
import 'package:todo_app/widgets/task_list.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  String _selectedDate =
      DateFormat('EEEE, d MMMM', 'en_US').format(DateTime.now());
  List<TodoTask> _registeredTask = [];
  List<TodoTask> _completedTasks = [];
  double completionPercentage = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _clearOutdatedTasks();
  }

  void _loadTasks() {
    DatabaseHelper.instance.getAllTasks().then((tasks) {
      setState(() {
        _registeredTask = tasks;
      });
    });
  }

  void _addTask(TodoTask task) {
    DatabaseHelper.instance.insertTask(task).then((insertedId) {
      setState(() {
        task.id = insertedId;
        _registeredTask.add(task);
      });
    });
  }

  void _removeTask(TodoTask task) async {
    await DatabaseHelper.instance.deleteTask(task);
    setState(() {
      _registeredTask.remove(task);
    });
  }

  void getCompletedTasks(List<TodoTask> completedTasks) {
    setState(() {
      _completedTasks = completedTasks;
    });
  }

  void _clearOutdatedTasks() {
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 7));
    List<TodoTask> outdatedTasks = _registeredTask
        .where((task) => DateFormat('EEEE, d MMMM', 'en_US')
            .parse(task.date)
            .isBefore(currentDate))
        .toList();
    setState(() {
      _registeredTask.removeWhere((task) => outdatedTasks.contains(task));
    });

    for (TodoTask task in outdatedTasks) {
      DatabaseHelper.instance.deleteTask(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TodoTask> filteredTasks =
        _registeredTask.where((task) => task.date == _selectedDate).toList();
    final List<TodoTask> filteredCompletedTasks =
        _completedTasks.where((task) => task.date == _selectedDate).toList();
    final List<TodoTask> incompleteTasks = _registeredTask
        .where((task) => !_completedTasks.contains(task))
        .toList();

    if (filteredTasks.isNotEmpty && filteredCompletedTasks.isNotEmpty) {
      completionPercentage =
          filteredCompletedTasks.length / filteredTasks.length;
    } else {
      completionPercentage = 0;
    }

    Widget mainContent = filteredTasks.isNotEmpty
        ? Row(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 8, 8, 8),
                  child: Container(
                    width: 4,
                    height: 400,
                    color: Colors.white,
                    child: FractionallySizedBox(
                      alignment: Alignment.topCenter,
                      heightFactor: completionPercentage,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  )),
              TaskList(
                inputTodoList: filteredTasks,
                onRemoveTask: _removeTask,
                onCompleteTask: getCompletedTasks,
              ),
            ],
          )
        : const Center(
            child: Text(
              'No Task Added Yet',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
          );

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.7)
                ], begin: Alignment.bottomLeft, end: Alignment.topRight),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.task,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Task Status",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task_alt),
              title: Text(
                'Completed Tasks',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetails(
                      name: 'Completed Tasks',
                      tasks: _completedTasks,
                      message: 'You have not completed any Task.',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.watch_later_outlined),
              title: Text(
                'Incomplete Tasks',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetails(
                      name: 'Incomplete Tasks',
                      tasks: incompleteTasks,
                      message: 'You do not have any Incomplete Task. ',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(children: [
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue,
            child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "My Task",
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.add_box_rounded),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewTask(
                                            onAddTask: _addTask,
                                          )));
                            },
                            iconSize: 60,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      Text(
                        "Today",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      DatePicker(
                        DateTime.now(),
                        width: 60,
                        height: 90,
                        dayTextStyle:
                            const TextStyle(color: Colors.blue, fontSize: 11),
                        initialSelectedDate: DateTime.now(),
                        selectionColor: Colors.blue,
                        selectedTextColor: Colors.white,
                        daysCount: 7,
                        onDateChange: (selectedDate) {
                          setState(() {
                            _selectedDate = DateFormat('EEEE, d MMMM', 'en_US')
                                .format(selectedDate);
                          });
                        },
                      )
                    ],
                  ),
                )),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: mainContent,
            ),
          ),
        )
      ]),
    );
  }
}
