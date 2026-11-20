import 'package:reelora/core/result/result.dart';
import 'package:reelora/features/home/domain/entities/greeting.dart';

abstract interface class HomeRepository {
  Future<Result<Greeting>> getGreeting();
}
