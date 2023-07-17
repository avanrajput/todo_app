import 'package:flutter/material.dart';

enum Category { call, travel, mail, meeting, study }

const categoryIcons = {
  Category.call: Icons.call,
  Category.travel: Icons.flight,
  Category.mail: Icons.mail,
  Category.meeting: Icons.meeting_room,
  Category.study: Icons.book
};

class TodoTask {
  int? id;
  final String title;
  final Category category;
  final String date;
  final String startTime;
  final String endTime;
  final String description;

  TodoTask({
    this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.description,
  });

  TodoTask copyWith({
    int? id,
    String? title,
    Category? category,
    String? date,
    String? startTime,
    String? endTime,
    String? description,
  }) {
    return TodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'description': description,
    };
  }

  static TodoTask fromMap(Map<String, dynamic> map) {
    return TodoTask(
      id: map['id'],
      title: map['title'],
      category: Category.values.firstWhere(
        (category) => category.name == map['category'],
      ),
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      description: map['description'],
    );
  }

  IconData getIconData() {
    return categoryIcons[category] ?? Icons.category;
  }
}
