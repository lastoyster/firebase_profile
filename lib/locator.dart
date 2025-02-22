import 'package:firebase_profile/repository/auth_repo.dart';
import 'package:firebase_profile/repository/storage_repo.dart';
import 'package:firebase_profile/view_controller/user_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<UserController>(UserController());
}
