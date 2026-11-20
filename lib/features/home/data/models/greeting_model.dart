import 'package:reelora/features/home/domain/entities/greeting.dart';

class GreetingModel extends Greeting {
  const GreetingModel({
    required super.title,
    required super.subtitle,
    required super.timestamp,
  });

  factory GreetingModel.fromJson(Map<String, dynamic> json) {
    return GreetingModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
