import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Импортируем пакет intl

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;
  final Function? onEdit; // Функция для редактирования
  final Function? onDelete;
  final Function? toLeft;
  final Function? toRight; // Функция для удаления

  // ignore: use_super_parameters
  const TaskItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    required
    this.onEdit,
    this.onDelete,
     this.toLeft, 
     this.toRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);

    // Определяем срочность задачи
    Duration timeUntilDeadline = deadline.difference(DateTime.now());
    Color gradientStart;
    if (timeUntilDeadline.inDays < 1) {
      gradientStart = Colors.red; // Срочная
    } else if (timeUntilDeadline.inDays < 2) {
      gradientStart = Colors.yellow; // Средняя срочность
    } else {
      gradientStart = Colors.green; // Не срочная
    }

    return Dismissible(
      key: Key(title), // Уникальный ключ для Dismissible
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          toLeft?.call(); // Вызываем функцию удаления
        } else if (direction == DismissDirection.startToEnd) {
          toRight?.call(); // Вызываем функцию редактирования
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradientStart, Colors.white],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Цвет текста черный
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onEdit as void Function()?,
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: onDelete as void Function()?,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Дедлайн: $formattedDeadline', // Используем отформатированную дату
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
