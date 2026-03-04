import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/checklist_entity.dart';
import '../bloc/checklist_bloc.dart';
import '../bloc/checklist_event.dart';
import '../bloc/checklist_state.dart';
import '../widgets/config_option_card.dart';

/// Page for configuring checklist generation options
class ChecklistConfigPage extends StatefulWidget {
  final VoidCallback? onGenerated;

  const ChecklistConfigPage({
    super.key,
    this.onGenerated,
  });

  @override
  State<ChecklistConfigPage> createState() => _ChecklistConfigPageState();
}

class _ChecklistConfigPageState extends State<ChecklistConfigPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  HikerExperience _experience = HikerExperience.newbie;
  TrekDuration _duration = TrekDuration.halfDay;
  WeatherCondition _weather = WeatherCondition.mild;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onGenerate() {
    context.read<ChecklistBloc>().add(GenerateChecklistEvent(
          experience: _experience,
          duration: _duration,
          weather: _weather,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChecklistBloc, ChecklistState>(
      listener: (context, state) {
        if (state is ChecklistGenerated) {
          widget.onGenerated?.call();
        } else if (state is ChecklistError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '🎒',
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pack Smart',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tell us about your trek and we\'ll create a personalized packing list',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Experience Level
              const ConfigSectionHeader(
                title: 'Your Experience Level',
                subtitle: 'This helps us adjust the list complexity',
                icon: Icons.hiking,
              ),
              Row(
                children: [
                  Expanded(
                    child: ConfigOptionCard<HikerExperience>(
                      title: HikerExperience.newbie.displayName,
                      icon: '🥾',
                      subtitle: 'First time or occasional',
                      value: HikerExperience.newbie,
                      groupValue: _experience,
                      onChanged: (value) => setState(() => _experience = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ConfigOptionCard<HikerExperience>(
                      title: HikerExperience.experienced.displayName,
                      icon: '🏔️',
                      subtitle: 'Regular trekker',
                      value: HikerExperience.experienced,
                      groupValue: _experience,
                      onChanged: (value) => setState(() => _experience = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Trek Duration
              const ConfigSectionHeader(
                title: 'Trek Duration',
                subtitle: 'How long will your adventure be?',
                icon: Icons.schedule,
              ),
              Row(
                children: [
                  Expanded(
                    child: ConfigOptionCard<TrekDuration>(
                      title: TrekDuration.halfDay.displayName,
                      icon: '🌤️',
                      subtitle: '< 6 hours',
                      value: TrekDuration.halfDay,
                      groupValue: _duration,
                      onChanged: (value) => setState(() => _duration = value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ConfigOptionCard<TrekDuration>(
                      title: TrekDuration.fullDay.displayName,
                      icon: '🌅',
                      subtitle: '6-12 hours',
                      value: TrekDuration.fullDay,
                      groupValue: _duration,
                      onChanged: (value) => setState(() => _duration = value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ConfigOptionCard<TrekDuration>(
                      title: TrekDuration.multiDay.displayName,
                      icon: '⛺',
                      subtitle: '> 1 day',
                      value: TrekDuration.multiDay,
                      groupValue: _duration,
                      onChanged: (value) => setState(() => _duration = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Weather Condition
              const ConfigSectionHeader(
                title: 'Expected Weather',
                subtitle: 'What conditions are you preparing for?',
                icon: Icons.cloud,
              ),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: WeatherCondition.values.map((weather) {
                  return ConfigOptionCard<WeatherCondition>(
                    title: weather.displayName,
                    icon: weather.icon,
                    value: weather,
                    groupValue: _weather,
                    onChanged: (value) => setState(() => _weather = value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Generate Button
              BlocBuilder<ChecklistBloc, ChecklistState>(
                builder: (context, state) {
                  final isLoading = state is ChecklistLoading;

                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onGenerate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome),
                                SizedBox(width: 8),
                                Text(
                                  'Generate My Checklist',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
