enum Priority { LOW, MED, HIGH }

class TodoModel {
  String? userId;
  String? title;
  String? desc;
  bool? isCompleted;
  String? createdAt;
  String? completedAt;
  Priority? priority;

  TodoModel({
    this.userId = "",
    required this.title,
    required this.desc,
    this.isCompleted = false,
    required this.createdAt,
    required this.completedAt,
    this.priority = Priority.LOW,
  });

  factory TodoModel.fromJSONDoc(Map<String, dynamic> jsonDoc) {
    return TodoModel(
        userId: jsonDoc['userId'],
        title: jsonDoc['title'],
        desc: jsonDoc['desc'],
        isCompleted: jsonDoc['isCompleted'],
        createdAt: jsonDoc['createdAt'],
        completedAt: jsonDoc['completedAt'],
        priority: jsonDoc['priority']);
  }

  Map<String, dynamic> toMapDoc() {
    return {
      'userId': userId,
      'title': title,
      'desc': desc,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'completedAt': completedAt,
      'priority': priority,
    };
  }
}
