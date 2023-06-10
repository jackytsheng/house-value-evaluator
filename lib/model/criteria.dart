import 'package:uuid/uuid.dart';

class NoteItem {
  NoteItem({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String noteId = const Uuid().v4();
  String? expandedValue;
  String? headerValue;
  bool isExpanded;

  Map<String, dynamic> toJson() {
    return {
      'noteId': noteId,
      'expandedValue': expandedValue,
      'headerValue': headerValue,
      'isExpanded': isExpanded,
    };
  }

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    var note = NoteItem(
      expandedValue: json['expandedValue'],
      headerValue: json['headerValue'],
      isExpanded: json['isExpanded'],
    );

    note.noteId = json['noteId'];
    return note;
  }
}

class CriteriaItemEntity {
  final String criteriaId;
  final List<NoteItem> notes;
  String criteriaName;
  double weighting;

  CriteriaItemEntity(
      this.criteriaId, this.notes, this.criteriaName, this.weighting);

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
      json['criteriaId'],
      (json['notes'] as List<dynamic>)
          .map((noteJson) => NoteItem.fromJson(noteJson))
          .toList(),
      json['criteriaName'],
      json['weighting'],
    );
  }
}
