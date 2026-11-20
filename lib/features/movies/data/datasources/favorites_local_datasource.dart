import 'dart:convert';

import 'package:movie_muse/core/config/env_config.dart';
import 'package:movie_muse/core/error/exceptions.dart';
import 'package:movie_muse/features/movies/data/models/movie_summary_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class FavoritesLocalDataSource {
  Future<List<MovieSummaryModel>> getFavorites();

  Future<List<MovieSummaryModel>> saveFavorites(
    List<MovieSummaryModel> favorites,
  );
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  const FavoritesLocalDataSourceImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<List<MovieSummaryModel>> getFavorites() async {
    final raw = _preferences.getString(EnvConfig.favoritesStorageKey);
    if (raw == null || raw.trim().isEmpty) {
      return const [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        throw const CacheException('Saved favorites format is corrupted.');
      }

      final result = <MovieSummaryModel>[];
      final seenIds = <String>{};
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final model = MovieSummaryModel.tryFromStorageJson(item);
          if (model != null && seenIds.add(model.imdbId)) {
            result.add(model);
          }
        } else if (item is Map) {
          final mapped = item.map(
            (key, value) => MapEntry(key.toString(), value),
          );
          final model = MovieSummaryModel.tryFromStorageJson(mapped);
          if (model != null && seenIds.add(model.imdbId)) {
            result.add(model);
          }
        }
      }
      return List<MovieSummaryModel>.unmodifiable(result);
    } on FormatException {
      throw const CacheException('Saved favorites JSON is corrupted.');
    } catch (error) {
      if (error is CacheException) {
        rethrow;
      }
      throw const CacheException('Unable to read saved favorites.');
    }
  }

  @override
  Future<List<MovieSummaryModel>> saveFavorites(
    List<MovieSummaryModel> favorites,
  ) async {
    final deduplicated = <MovieSummaryModel>[];
    final seenIds = <String>{};
    for (final item in favorites) {
      if (seenIds.add(item.imdbId)) {
        deduplicated.add(item);
      }
    }

    final encoded = jsonEncode(
      deduplicated.map((item) => item.toStorageJson()).toList(),
    );
    final saved = await _preferences.setString(
      EnvConfig.favoritesStorageKey,
      encoded,
    );
    if (!saved) {
      throw const CacheException('Could not persist favorite movies.');
    }
    return List<MovieSummaryModel>.unmodifiable(deduplicated);
  }
}
