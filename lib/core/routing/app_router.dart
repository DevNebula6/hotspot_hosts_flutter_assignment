import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotspot_hosts_flutter_assignment/screens/experience_selection_screen.dart';
import 'package:hotspot_hosts_flutter_assignment/screens/question_screen.dart';

class AppRoutes {
  static const String experienceSelection = '/';
  static const String question = '/question';
}

final router = GoRouter(
  initialLocation: AppRoutes.experienceSelection,
  routes: [
    GoRoute(
      path: AppRoutes.experienceSelection,
      name: 'experienceSelection',
      builder: (context, state) => const ExperienceSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.question,
      name: 'question',
      builder: (context, state) => const QuestionScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.matchedLocation}'),
    ),
  ),
);
