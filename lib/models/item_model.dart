// This is a Dart class,
// not a Flutter widget.
import 'dart:convert';

class ItemModel {
  final String title;
  final String description;
  final String date;

  ItemModel({
    required this.title,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      title: json['title'],
      description: json['description'],
      date: json['date'],
    );
  }
}
