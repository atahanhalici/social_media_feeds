import 'package:get_it/get_it.dart';
import 'package:social_media_feeds/repository/repository.dart';
import 'package:social_media_feeds/services/database_service.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => DatabaseService());
}