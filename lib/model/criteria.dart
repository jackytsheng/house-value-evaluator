import 'package:property_evaluator/model/note.dart';

class CriteriaItemEntity {
  final String criteriaId;
  List<NoteItem> notes;
  String criteriaName;
  double weighting;

  CriteriaItemEntity(
      {required this.criteriaId,
      this.notes = const [],
      this.criteriaName = "",
      this.weighting = 0});

  Map<String, dynamic> toJson() {
    return {
      'criteriaId': criteriaId,
      'notes': notes.map((note) => note.toJson()).toList(),
      'criteriaName': criteriaName,
      'weighting': weighting,
    };
  }

  factory CriteriaItemEntity.fromJson(Map<String, dynamic> json) {
    return CriteriaItemEntity(
      criteriaId: json['criteriaId'],
      notes: (json['notes'] as List<dynamic>)
          .map((noteJson) => NoteItem.fromJson(noteJson))
          .toList(),
      criteriaName: json['criteriaName'],
      weighting: json['weighting'],
    );
  }
}
