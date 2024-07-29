import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/all_tasks.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/theme/theme.dart'; // Import theme
import 'package:intl/intl.dart'; // Импортируем пакет intl

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    Text('Сегодня'),
    Text('Выполнено'),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для добавления новой задачи
  void _addNewTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Переменные для хранения данных новой задачи
        String title = '';
        String description = '';
        DateTime deadline = DateTime.now();

        return Dialog( // Используем Dialog вместо AlertDialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Добавляем скругленные углы
          ),
          child: Container(
            width: 400, // Устанавливаем ширину диалога
            padding: const EdgeInsets.all(20), // Добавляем отступ
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Поле для ввода названия задачи
                TextField(
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Название задачи',
                  ),
                ),
                const SizedBox(height: 16),
                // Поле для ввода описания задачи
                TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Описание задачи',
                  ),
                ),
                const SizedBox(height: 16),
                // Виджет для выбора дедлайна
                Padding( // Добавляем отступ для кнопки
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Открываем диалог выбора даты и времени
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      ).then((pickedDate) {
                        if (pickedDate == null) return;
                        // Открываем диалог выбора времени
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(pickedDate), // Используем выбранную дату для начального времени
                        ).then((pickedTime) {
                          if (pickedTime == null) return;
                          // Собираем дату и время
                          deadline = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      });
                    },
                    child: const Text('Выбрать дедлайн'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container( // Wrap the body with Container
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DoDidDoneTheme.lightTheme.colorScheme.primary,
              DoDidDoneTheme.lightTheme.colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // Добавляем плавающую кнопку
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
