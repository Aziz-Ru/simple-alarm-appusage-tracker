class TimeModel {
  final int id;
  final String title;
  final String description;
  final DateTime scheduledTime;

  TimeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledTime,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledTime': scheduledTime.toIso8601String(),
    };
  }
}
