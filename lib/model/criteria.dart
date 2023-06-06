import 'package:uuid/uuid.dart';

class NoteItem {
  NoteItem({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String noteId = Uuid().v4();
  String? expandedValue;
  String? headerValue;
  bool isExpanded;
}

class CriteriaItemEntity {
  final String criteriaId;
  final List<NoteItem> notes;
  String criteriaName;
  double weighting;

  CriteriaItemEntity(
      this.criteriaId, this.notes, this.criteriaName, this.weighting);
}
