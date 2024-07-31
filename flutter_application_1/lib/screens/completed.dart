// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/task_item.dart';

class CompletedPage extends StatefulWidget {
  // ignore: use_super_parameters
  const CompletedPage({Key? key}) : super(key: key);

  @override
  State<CompletedPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<CompletedPage> {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _tasksCollection.where('completed', isEqualTo: true).snapshots(),
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
             toLeft: (){
                _tasksCollection
                  .doc(tasks[index].id)
                  .update({'is_for_today': true, 'completed': false});
             },

             toRight: (){
               _tasksCollection
                  .doc(tasks[index].id)
                  .update({'is_for_day': false ,'completed': false});
             },

             onEdit: (){

             },

             onDelete: (){
               _tasksCollection.doc(tasks[index].id).delete();
             },
            );
          },
        );
      },
    );
  }
}
