class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  AppNotification({required this.id, required this.title, required this.message, required this.date, this.isRead = false});

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'message': message, 'date': date.toIso8601String(), 'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'], title: json['title'], message: json['message'], date: DateTime.parse(json['date']), isRead: json['isRead'] ?? false,
  );
}
