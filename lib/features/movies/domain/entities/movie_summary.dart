import 'package:equatable/equatable.dart';

class MovieSummary extends Equatable {
  const MovieSummary({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
    this.type,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? poster;
  final String? type;

  String? get displayType {
    final value = type?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  String get subtitleMeta {
    final formattedType = displayType;
    if (formattedType == null) {
      return year;
    }
    return '$year  ·  $formattedType';
  }

  String get monogram {
    final words = title
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) {
      return 'MV';
    }
    if (words.length == 1) {
      final first = words.first;
      return first.substring(0, first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  @override
  List<Object?> get props => [imdbId, title, year, poster, type];
}
