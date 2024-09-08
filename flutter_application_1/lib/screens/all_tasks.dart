// ignore_for_file: unused_local_variable, unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/services/firebase_auth.dart';
import 'package:flutter_application_1/widgets/dialog_widget.dart';
import '../widgets/task_item.dart';

class TasksPage extends StatefulWidget {
  // ignore: use_super_parameters
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');
  final _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection
          .where('userId', isEqualTo: user?.uid)
          .where('completed', isEqualTo: false)
          .where('is_for_today', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Ошибка при загрузке задач'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data!.docs;

        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              'Нет задач, время отдыхать.. \n или создать новую..'));
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final taskData = tasks[index].data() as Map<String, dynamic>;
            final taskTitle = taskData['title'];
            final taskDescription = taskData['description'];
            final taskDeadline = (taskData['deadline'] as Timestamp).toDate();

            return TaskItem(
              title: taskTitle,
              description: taskDescription,
              deadline: taskDeadline,
              // Добавьте другие поля из вашей коллекции tasks
              toLeft: () {
                _tasksCollection
                    .doc(tasks[index].id)
                    .update({'completed': true});
              },
              toRight: () {
                _tasksCollection
                    .doc(tasks[index].id)
                    .update({'is_for_today': true});
              },
              onEdit: () {
                final user = _authService.getCurrentUser(); // Get the user here
                showDialog(
                  context: context,
                  builder: (context) {
                    return DialogWidget(
                      taskId: tasks[index].id,
                      title: taskTitle,
                      description: taskDescription,
                      user: user, // Pass the user object
                    );
                  },
                );
              },
              onDelete: () {
                _tasksCollection.doc(tasks[index].id).delete();
              },
            );
          },
        );
      },
    );
  }
}
