import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Base state for theme management
abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

/// Initial theme state
class ThemeInitial extends ThemeState {
  const ThemeInitial({required super.themeMode});
}

/// Light theme state
class LightThemeState extends ThemeState {
  const LightThemeState() : super(themeMode: ThemeMode.light);

  @override
  List<Object?> get props => [themeMode];
}

/// Dark theme state
class DarkThemeState extends ThemeState {
  const DarkThemeState() : super(themeMode: ThemeMode.dark);

  @override
  List<Object?> get props => [themeMode];
}

/// System theme state (auto-switch based on device settings)
class SystemThemeState extends ThemeState {
  const SystemThemeState() : super(themeMode: ThemeMode.system);

  @override
  List<Object?> get props => [themeMode];
}

/// Auto theme state — switches based on time of day
/// Night: 7 PM–6 AM → Dark  |  Day: 6 AM–7 PM → Light
class AutoThemeState extends ThemeState {
  const AutoThemeState({required super.themeMode});

  @override
  List<Object?> get props => [themeMode];
}

/// Theme error state
class ThemeError extends ThemeState {
  final String message;

  const ThemeError({required this.message}) : super(themeMode: ThemeMode.system);

  @override
  List<Object?> get props => [themeMode, message];
}
