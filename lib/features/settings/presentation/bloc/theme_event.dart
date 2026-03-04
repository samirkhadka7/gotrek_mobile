import 'package:equatable/equatable.dart';

/// Base event for theme management
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to set light theme
class SetLightThemeEvent extends ThemeEvent {
  const SetLightThemeEvent();
}

/// Event to set dark theme
class SetDarkThemeEvent extends ThemeEvent {
  const SetDarkThemeEvent();
}

/// Event to set system theme (auto-switch based on device settings)
class SetSystemThemeEvent extends ThemeEvent {
  const SetSystemThemeEvent();
}

/// Event to toggle between light and dark theme
class ToggleThemeEvent extends ThemeEvent {
  const ToggleThemeEvent();
}

/// Event to set auto theme (ambient light sensor based)
class SetAutoThemeEvent extends ThemeEvent {
  const SetAutoThemeEvent();
}

/// Internal event: fired by ambient light sensor stream with lux reading
class LightSensorUpdateEvent extends ThemeEvent {
  final int lux;
  const LightSensorUpdateEvent(this.lux);

  @override
  List<Object?> get props => [lux];
}

/// Event to load saved theme preference
class LoadThemePreferenceEvent extends ThemeEvent {
  const LoadThemePreferenceEvent();
}
