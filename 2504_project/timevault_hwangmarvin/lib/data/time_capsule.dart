import 'package:hive/hive.dart';

part 'time_capsule.g.dart'; // This file is generated by running the build runner

@HiveType(typeId: 0)
class TimeCapsule extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final String description; 

  @HiveField(3)
  final DateTime unlockDate;

  @HiveField(4)
  bool isArchived;

  TimeCapsule({
    required this.title,
    required this.message,
    required this.description, 
    required this.unlockDate,
    this.isArchived = false,
  });
}
