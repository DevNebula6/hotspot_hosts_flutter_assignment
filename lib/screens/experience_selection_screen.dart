import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/experience/experience_state.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_bloc.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_event.dart';
import 'package:hotspot_hosts_flutter_assignment/blocs/selection/selection_state.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_colors.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_spacing.dart';
import 'package:hotspot_hosts_flutter_assignment/core/constants/app_text_styles.dart';
import 'package:hotspot_hosts_flutter_assignment/models/experience.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/custom_text_field.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/experience_card.dart';
import 'package:hotspot_hosts_flutter_assignment/widgets/loading_and_error_widgets.dart';

/// Experience selection screen
class ExperienceSelectionScreen extends StatefulWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  State<ExperienceSelectionScreen> createState() => _ExperienceSelectionScreenState();
}

class _ExperienceSelectionScreenState extends State<ExperienceSelectionScreen> {
  final TextEditingController _notesController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasTextInput = false;

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      final hasText = _notesController.text.trim().isNotEmpty;
      if (hasText != _hasTextInput) {
        setState(() {
          _hasTextInput = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      appBar: AppBar(
        backgroundColor: AppColors.base2Dark,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text1),
          onPressed: () {
            // Back button
          },
        ),
        title: _ProgressIndicator(currentStep: 1, totalSteps: 3),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.text1),
            onPressed: () {
              // Close button
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
                'assets/icons/image25.svg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              )
          ),
          BlocBuilder<ExperienceBloc, ExperienceState>(
            builder: (context, state) {
              if (state is ExperienceLoading) {
                return const LoadingIndicator(message: 'Loading experiences...');
              } else if (state is ExperienceLoaded) {
                return _ExperienceContent(
                  experiences: state.experiences,
                  notesController: _notesController,
                  hasTextInput: _hasTextInput,
                  scrollController: _scrollController,
                );
              } else if (state is ExperienceError) {
                return ErrorDisplay(
                  message: state.message,
                  onRetry: () {
                    context.read<ExperienceBloc>().add(const RetryFetchExperiences());
                  },
                );
              }
              return const Center(child: Text('Welcome!'));
            },
          ),
        ],
      ),
    );
  }
}

class _ExperienceContent extends StatelessWidget {
  final List<Experience> experiences;
  final TextEditingController notesController;
  final bool hasTextInput;
  final ScrollController scrollController;

  const _ExperienceContent({
    required this.experiences,
    required this.notesController,
    required this.hasTextInput,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectionBloc, SelectionState>(
      builder: (context, selectionState) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Question text
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Text(
                      'What kind of experiences do you want to host?',
                      style: AppTextStyles.h2Bold.copyWith(
                        color: AppColors.text1,
                        fontSize: 24,
                        height: 1.3,
                      ),
                    ),
                  ),
                  
                  // Horizontal scrollable experience cards
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: experiences.length,
                      itemBuilder: (context, index) {
                        final experience = experiences[index];
                        final isSelected = selectionState.isSelected(experience.id);
                        
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < experiences.length - 1 ? AppSpacing.md : 0,
                          ),
                          child: ExperienceStampCard(
                            experience: experience,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<SelectionBloc>().add(
                                ToggleExperienceSelection(experience.id),
                              );
                              
                              // Animate to show first selected card
                              if (!isSelected && selectionState.selectedIds.isEmpty) {
                                // First selection - scroll to this card
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  final cardWidth = 120.0 + AppSpacing.md;
                                  scrollController.animateTo(
                                    index * cardWidth,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.lg),
                  
                  // Notes input section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Notes input
                        CustomTextField(
                          controller: notesController,
                          hintText: '/ Describe your perfect hotspot',
                          maxLines: 4,
                          maxLength: 250,
                          onChanged: (value) {
                            // Update notes in bloc if needed
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom next button
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xxl, left: AppSpacing.lg, right: AppSpacing.lg),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: selectionState.selectedIds.isEmpty
                              ? null
                              : LinearGradient(
                                  colors: [
                                    const Color(0xFF2A2A2A), 
                                    const Color(0xFF404040), 
                                    const Color(0xFF2A2A2A),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.centerRight,
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectionState.selectedIds.isEmpty
                                ? AppColors.border1
                                : const Color(0xFF555555),
                            width: 1,
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectionState.selectedIds.isEmpty
                                ? AppColors.border1
                                : Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: selectionState.selectedIds.isEmpty
                              ? null
                              : () {
                                  // Log selected data
                                  debugPrint('=== Selected Experiences ===');
                                  debugPrint('Count: ${selectionState.selectedIds.length}');
                                  debugPrint('IDs: ${selectionState.selectedIds}');
                                  debugPrint('Notes: ${notesController.text}');
                                  
                                  final selectedExperiences = experiences
                                      .where((e) => selectionState.isSelected(e.id))
                                      .toList();
                                      
                                  for (final exp in selectedExperiences) {
                                    debugPrint('- ${exp.name} (ID: ${exp.id})');
                                  }
                                  
                                  // Navigate to question screen
                                  context.push('/question');
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: AppTextStyles.buttonBold.copyWith(
                                  fontSize: 20,
                                  color: selectionState.selectedIds.isEmpty
                                    ? AppColors.textTertiary : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(Icons.arrow_forward, color: selectionState.selectedIds.isEmpty
                                    ? AppColors.textTertiary : AppColors.textPrimary,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ], 
              ), 
            ), 
          ),
        ); 
      }, 
    );
  }
}

/// Progress indicator widget for app bar
class _ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.border1,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: currentStep / totalSteps,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
