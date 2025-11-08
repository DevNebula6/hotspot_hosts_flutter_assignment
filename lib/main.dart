import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_theme.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_constants.dart';
import 'package:hotspot_hosts_flutter_assignment/core/di/dependency_injection.dart';
import 'package:hotspot_hosts_flutter_assignment/core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  setupDependencyInjection();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.base,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExperienceBloc>(
          create: (context) => getIt<ExperienceBloc>()..add(const FetchExperiences()),
        ),
        BlocProvider<SelectionBloc>(
          create: (context) => getIt<SelectionBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

