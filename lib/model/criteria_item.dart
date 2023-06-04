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
  final String criteriaId = Uuid().v4();
  final String criteriaName;
  final List<NoteItem> comments;
  final double weighting;

  CriteriaItemEntity(this.comments, this.criteriaName, this.weighting);
}
