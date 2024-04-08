// POJO (Plain Old Java Object)
class Tasks {
  final int? taskId;
  final String? taskName;
  final String? taskDescription;
  final String? date;
  Tasks(
     {
    required this.taskId,
    required this.taskName,
    required this.taskDescription,
    required this.date,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      taskId: json['taskId'],
      taskName: json['taskName'],
      taskDescription: json['taskDescription'],
      date: json['date'],
    );
  }
}
