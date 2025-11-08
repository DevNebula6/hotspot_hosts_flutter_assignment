import 'package:get_it/get_it.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/repositories/experience_repository.dart';
import 'package:hotspot_hosts_flutter_assignment/services/api_client.dart';
import 'package:hotspot_hosts_flutter_assignment/services/experience_service.dart';

/// Service locator instance
final getIt = GetIt.instance;

/// Setup dependency injection
void setupDependencyInjection() {
  // API Client (singleton)
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Services
  getIt.registerLazySingleton<ExperienceService>(
    () => ExperienceService(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ExperienceRepository>(
    () => ExperienceRepository(getIt<ExperienceService>()),
  );

  // BLoCs (factories - new instance each time)
  getIt.registerFactory<ExperienceBloc>(
    () => ExperienceBloc(getIt<ExperienceRepository>()),
  );

  getIt.registerFactory<SelectionBloc>(
    () => SelectionBloc(),
  );
}
