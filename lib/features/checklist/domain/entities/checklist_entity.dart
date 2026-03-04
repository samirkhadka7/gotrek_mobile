import 'package:equatable/equatable.dart';

/// Checklist configuration
class ChecklistConfig extends Equatable {
  final HikerExperience experience;
  final TrekDuration duration;
  final WeatherCondition weather;

  const ChecklistConfig({
    required this.experience,
    required this.duration,
    required this.weather,
  });

  @override
  List<Object?> get props => [experience, duration, weather];
}

/// Hiker experience levels
enum HikerExperience {
  newbie,
  experienced;

  String get displayName {
    switch (this) {
      case HikerExperience.newbie:
        return 'New Trekker';
      case HikerExperience.experienced:
        return 'Experienced';
    }
  }

  String get apiValue {
    switch (this) {
      case HikerExperience.newbie:
        return 'new';
      case HikerExperience.experienced:
        return 'experienced';
    }
  }

  static HikerExperience fromString(String value) {
    switch (value.toLowerCase()) {
      case 'experienced':
        return HikerExperience.experienced;
      default:
        return HikerExperience.newbie;
    }
  }
}

/// Trek duration options
enum TrekDuration {
  halfDay,
  fullDay,
  multiDay;

  String get displayName {
    switch (this) {
      case TrekDuration.halfDay:
        return 'Half Day';
      case TrekDuration.fullDay:
        return 'Full Day';
      case TrekDuration.multiDay:
        return 'Multi-Day';
    }
  }

  String get apiValue {
    switch (this) {
      case TrekDuration.halfDay:
        return 'half-day';
      case TrekDuration.fullDay:
        return 'full-day';
      case TrekDuration.multiDay:
        return 'multi-day';
    }
  }

  static TrekDuration fromString(String value) {
    switch (value.toLowerCase()) {
      case 'full-day':
        return TrekDuration.fullDay;
      case 'multi-day':
        return TrekDuration.multiDay;
      default:
        return TrekDuration.halfDay;
    }
  }
}

/// Weather conditions
enum WeatherCondition {
  mild,
  hot,
  cold,
  rainy;

  String get displayName {
    switch (this) {
      case WeatherCondition.mild:
        return 'Mild';
      case WeatherCondition.hot:
        return 'Hot';
      case WeatherCondition.cold:
        return 'Cold';
      case WeatherCondition.rainy:
        return 'Rainy';
    }
  }

  String get apiValue => name;

  String get icon {
    switch (this) {
      case WeatherCondition.mild:
        return '🌤️';
      case WeatherCondition.hot:
        return '☀️';
      case WeatherCondition.cold:
        return '❄️';
      case WeatherCondition.rainy:
        return '🌧️';
    }
  }

  static WeatherCondition fromString(String value) {
    switch (value.toLowerCase()) {
      case 'hot':
        return WeatherCondition.hot;
      case 'cold':
        return WeatherCondition.cold;
      case 'rainy':
        return WeatherCondition.rainy;
      default:
        return WeatherCondition.mild;
    }
  }
}

/// Checklist item
class ChecklistItem extends Equatable {
  final String id;
  final String name;
  final String category;
  final bool isChecked;

  const ChecklistItem({
    required this.id,
    required this.name,
    required this.category,
    this.isChecked = false,
  });

  ChecklistItem copyWith({
    String? id,
    String? name,
    String? category,
    bool? isChecked,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  @override
  List<Object?> get props => [id, name, category, isChecked];
}

/// User's saved checklist
class UserChecklist extends Equatable {
  final List<ChecklistItem> items;
  final ChecklistConfig config;
  final DateTime? updatedAt;

  const UserChecklist({
    required this.items,
    required this.config,
    this.updatedAt,
  });

  /// Group items by category
  Map<String, List<ChecklistItem>> get groupedItems {
    final Map<String, List<ChecklistItem>> grouped = {};
    for (final item in items) {
      if (!grouped.containsKey(item.category)) {
        grouped[item.category] = [];
      }
      grouped[item.category]!.add(item);
    }
    return grouped;
  }

  /// Calculate progress
  double get progress {
    if (items.isEmpty) return 0;
    final checkedCount = items.where((item) => item.isChecked).length;
    return checkedCount / items.length;
  }

  int get checkedCount => items.where((item) => item.isChecked).length;

  @override
  List<Object?> get props => [items, config, updatedAt];
}

/// Generated checklist response from API
class GeneratedChecklist extends Equatable {
  final Map<String, List<String>> itemsByCategory;

  const GeneratedChecklist({required this.itemsByCategory});

  List<ChecklistItem> toChecklistItems() {
    final items = <ChecklistItem>[];
    int idCounter = 0;

    itemsByCategory.forEach((category, itemNames) {
      for (final name in itemNames) {
        items.add(ChecklistItem(
          id: 'item_${idCounter++}',
          name: name,
          category: category,
          isChecked: false,
        ));
      }
    });

    return items;
  }

  @override
  List<Object?> get props => [itemsByCategory];
}
