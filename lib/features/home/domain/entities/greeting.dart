import 'package:equatable/equatable.dart';

class Greeting extends Equatable {
  const Greeting({
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final String title;
  final String subtitle;
  final DateTime timestamp;

  @override
  List<Object?> get props => [title, subtitle, timestamp];
}
