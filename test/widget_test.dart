import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_muse/app/app.dart';
import 'package:movie_muse/app/di/injection.dart';
import 'package:movie_muse/core/result/result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_search_result.dart';
import 'package:movie_muse/features/movies/domain/entities/movie_summary.dart';
import 'package:movie_muse/features/movies/domain/repositories/movie_repository.dart';
import 'package:movie_muse/features/saved/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeMovieRepository implements MovieRepository {
  static const batmanBegins = MovieSummary(
    imdbId: 'tt0372784',
    title: 'Batman Begins',
    year: '2005',
    type: 'movie',
  );

  static const darkKnight = MovieSummary(
    imdbId: 'tt0468569',
    title: 'The Dark Knight',
    year: '2008',
    type: 'movie',
  );

  static const phantasm = MovieSummary(
    imdbId: 'tt0106364',
    title: 'Batman: Mask of the Phantasm',
    year: '1993',
    type: 'movie',
  );

  @override
  Future<Result<MovieSearchResult>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    final normalized = query.toLowerCase();
    if (normalized.contains('batman')) {
      return const Success(
        MovieSearchResult(
          movies: [batmanBegins, darkKnight, phantasm],
          totalResults: 3,
        ),
      );
    }
    return const Success(MovieSearchResult(movies: [], totalResults: 0));
  }

  @override
  Future<Result<MovieDetail>> getMovieDetail(String imdbId) async {
    return const Success(
      MovieDetail(
        imdbId: 'tt0372784',
        title: 'Batman Begins',
        year: '2005',
        plot: 'Bruce learns to confront injustice and returns to Gotham as Batman.',
        genre: 'Action, Crime, Drama',
        director: 'Christopher Nolan',
        actors: 'Christian Bale, Michael Caine, Liam Neeson',
        runtime: '140 min',
        imdbRating: '8.2',
        released: '15 Jun 2005',
      ),
    );
  }
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    await resetDependencies();
    SharedPreferences.setMockInitialValues({});
    await configureDependencies(
      movieRepository: _FakeMovieRepository(),
      searchDebounceDuration: const Duration(milliseconds: 10),
    );
    await getIt<FavoritesViewModel>().load();
  });

  tearDown(() async {
    await resetDependencies();
  });

  testWidgets(
    'renders Discover, syncs Favorites to Saved, searches live, and opens Detail',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MovieMuseApp());
      await tester.pumpAndSettle();

      // 1. Discover screen renders editorial hero and movie list
      expect(find.text('A good film\nstarts here.'), findsOneWidget);
      expect(find.text('FEATURED FILM'), findsOneWidget);
      expect(find.text('Batman Begins'), findsOneWidget);
      expect(find.text('The Dark Knight'), findsOneWidget);

      // 2. Saved tab starts empty and "Explore movies" switches back to Discover
      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();
      expect(find.text('Your watchlist is empty.'), findsOneWidget);

      await tester.tap(find.text('Explore movies'));
      await tester.pumpAndSettle();

      // 3. Toggle favorite on The Dark Knight and verify sync in Saved tab
      await tester.tap(
        find.bySemanticsLabel('Save The Dark Knight to favorites'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();
      expect(find.text('1 film'), findsOneWidget);
      expect(find.text('Available offline'), findsOneWidget);
      expect(find.text('The Dark Knight'), findsOneWidget);

      // 4. Switch to Search tab, verify idle state, type query live
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.text('What are you in the\nmood for?'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'batman');
      await tester.pump(const Duration(milliseconds: 30));
      await tester.pumpAndSettle();

      expect(find.text('3 matches'), findsOneWidget);
      expect(find.text('Batman: Mask of the Phantasm'), findsOneWidget);

      // 5. Open MovieDetailView from Featured Card on Discover
      await tester.tap(find.text('Discover'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();

      expect(find.text('THE STORY'), findsOneWidget);
      expect(find.text('DIRECTOR'), findsOneWidget);
      expect(find.text('Christopher Nolan'), findsOneWidget);
      expect(find.text('RELEASED'), findsOneWidget);
      expect(find.text('15 Jun 2005'), findsOneWidget);
      expect(find.text('Christian Bale'), findsOneWidget);
      expect(find.text('8.2'), findsOneWidget);
      expect(find.text('N/A'), findsNothing);

      // 6. Verify smooth parallax scroll on MovieDetailView without render errors
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -160),
      );
      await tester.pumpAndSettle();
      expect(find.text('BACK'), findsOneWidget);
    },
  );
}
