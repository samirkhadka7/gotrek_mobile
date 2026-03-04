import 'package:hive/hive.dart';

import '../../domain/entities/checklist_entity.dart';

part 'checklist_model.g.dart';

/// Model for checklist item from API
@HiveType(typeId: 20)
class ChecklistItemModel extends ChecklistItem {
  @HiveField(0)
  final String modelId;

  @HiveField(1)
  final String modelName;

  @HiveField(2)
  final String modelCategory;

  @HiveField(3)
  final bool modelIsChecked;

  const ChecklistItemModel({
    required this.modelId,
    required this.modelName,
    required this.modelCategory,
    this.modelIsChecked = false,
  }) : super(
          id: modelId,
          name: modelName,
          category: modelCategory,
          isChecked: modelIsChecked,
        );

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json, int index, String category) {
    return ChecklistItemModel(
      modelId: 'item_$index',
      modelName: json['name'] as String? ?? json.toString(),
      modelCategory: category,
      modelIsChecked: json['isChecked'] as bool? ?? false,
    );
  }

  factory ChecklistItemModel.fromString(String name, int index, String category) {
    return ChecklistItemModel(
      modelId: 'item_$index',
      modelName: name,
      modelCategory: category,
      modelIsChecked: false,
    );
  }

  factory ChecklistItemModel.fromEntity(ChecklistItem item) {
    return ChecklistItemModel(
      modelId: item.id,
      modelName: item.name,
      modelCategory: item.category,
      modelIsChecked: item.isChecked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': modelId,
      'name': modelName,
      'category': modelCategory,
      'isChecked': modelIsChecked,
    };
  }

  ChecklistItemModel copyWithModel({
    String? id,
    String? name,
    String? category,
    bool? isChecked,
  }) {
    return ChecklistItemModel(
      modelId: id ?? modelId,
      modelName: name ?? modelName,
      modelCategory: category ?? modelCategory,
      modelIsChecked: isChecked ?? modelIsChecked,
    );
  }
}

/// Model for checklist config
@HiveType(typeId: 21)
class ChecklistConfigModel extends ChecklistConfig {
  @HiveField(0)
  final HikerExperience modelExperience;

  @HiveField(1)
  final TrekDuration modelDuration;

  @HiveField(2)
  final WeatherCondition modelWeather;

  const ChecklistConfigModel({
    required this.modelExperience,
    required this.modelDuration,
    required this.modelWeather,
  }) : super(
          experience: modelExperience,
          duration: modelDuration,
          weather: modelWeather,
        );

  factory ChecklistConfigModel.fromEntity(ChecklistConfig config) {
    return ChecklistConfigModel(
      modelExperience: config.experience,
      modelDuration: config.duration,
      modelWeather: config.weather,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experience': modelExperience.apiValue,
      'duration': modelDuration.apiValue,
      'weather': modelWeather.apiValue,
    };
  }
}

/// Model for user's saved checklist
@HiveType(typeId: 22)
class UserChecklistModel extends UserChecklist {
  @HiveField(0)
  final List<ChecklistItemModel> modelItems;

  @HiveField(1)
  final ChecklistConfigModel modelConfig;

  @HiveField(2)
  final DateTime? modelUpdatedAt;

  const UserChecklistModel({
    required this.modelItems,
    required this.modelConfig,
    this.modelUpdatedAt,
  }) : super(
          items: modelItems,
          config: modelConfig,
          updatedAt: modelUpdatedAt,
        );

  factory UserChecklistModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final configJson = json['config'] as Map<String, dynamic>? ?? {};

    final items = <ChecklistItemModel>[];
    int index = 0;

    // Parse items - could be grouped by category or flat list
    if (json['checklist'] != null) {
      final checklist = json['checklist'] as Map<String, dynamic>;
      checklist.forEach((category, categoryItems) {
        if (categoryItems is List) {
          for (final item in categoryItems) {
            if (item is String) {
              items.add(ChecklistItemModel.fromString(item, index++, category));
            } else if (item is Map<String, dynamic>) {
              items.add(ChecklistItemModel.fromJson(item, index++, category));
            }
          }
        }
      });
    } else {
      for (final item in itemsJson) {
        if (item is Map<String, dynamic>) {
          items.add(ChecklistItemModel(
            modelId: item['id'] as String? ?? 'item_$index',
            modelName: item['name'] as String? ?? '',
            modelCategory: item['category'] as String? ?? 'General',
            modelIsChecked: item['isChecked'] as bool? ?? false,
          ));
          index++;
        }
      }
    }

    return UserChecklistModel(
      modelItems: items,
      modelConfig: ChecklistConfigModel(
        modelExperience: HikerExperience.fromString(
          configJson['experience'] as String? ?? 'new',
        ),
        modelDuration: TrekDuration.fromString(
          configJson['duration'] as String? ?? 'half-day',
        ),
        modelWeather: WeatherCondition.fromString(
          configJson['weather'] as String? ?? 'mild',
        ),
      ),
      modelUpdatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  factory UserChecklistModel.fromEntity(UserChecklist checklist) {
    return UserChecklistModel(
      modelItems: checklist.items
          .map((item) => ChecklistItemModel.fromEntity(item))
          .toList(),
      modelConfig: ChecklistConfigModel.fromEntity(checklist.config),
      modelUpdatedAt: checklist.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': modelItems.map((item) => item.toJson()).toList(),
      'config': modelConfig.toJson(),
      'updatedAt': modelUpdatedAt?.toIso8601String(),
    };
  }
}

/// Model for generated checklist response from API
class GeneratedChecklistModel extends GeneratedChecklist {
  const GeneratedChecklistModel({required super.itemsByCategory});

  factory GeneratedChecklistModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> itemsByCategory = {};

    // The API returns checklist grouped by category
    final checklist = json['checklist'] as Map<String, dynamic>? ?? json;

    checklist.forEach((category, items) {
      if (items is List) {
        itemsByCategory[category] = items.map((e) => e.toString()).toList();
      }
    });

    return GeneratedChecklistModel(itemsByCategory: itemsByCategory);
  }
}
