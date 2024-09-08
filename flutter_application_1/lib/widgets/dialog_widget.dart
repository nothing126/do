// ignore_for_file: use_build_context_synchronously


import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({
    super.key,
    this.description,
    this.deadline,
    this.title,
    this.taskId, // ID задачи для редактирования
    required this.user, // Add user parameter
  });

  final String? description;
  final DateTime? deadline;
  final String? title;
  final String? taskId; // ID задачи для редактирования
  final User? user; // Add user parameter

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? _title;
  String? _description;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _description = widget.description;
    _deadline = widget.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Название'),
                controller: TextEditingController(text: _title),
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Описание'),
                controller: TextEditingController(text: _description),
                onChanged: (value) {
                  _description = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Дедлайн: ${DateFormat('dd.MM.yy HH:mm').format(_deadline ?? DateTime.now())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: _deadline ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_deadline ?? DateTime.now()),
                            ).then((pickedTime) {
                              if (pickedTime != null) {
                                setState(() {
                                  _deadline = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            });
                          }
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final tasksCollection =
                          FirebaseFirestore.instance.collection("tasks");

                      if (widget.taskId != null) {
                        // Редактирование существующей задачи
                        await tasksCollection.doc(widget.taskId).update({
                          'title': _title,
                          'description': _description,
                          'deadline': _deadline,
                        });
                      } else {
                        // Создание новой задачи
                          await tasksCollection.add({
                          'title': _title,
                          'description': _description,
                          'deadline': _deadline,
                          'completed': false,
                          'is_for_today': false,
                          'userId': widget.user?.uid, // Use widget.user here
                        });
                      }

                      Navigator.pop(context);
                    },
                    child: Text(widget.taskId != null ? 'Сохранить' : 'Добавить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
  }
}