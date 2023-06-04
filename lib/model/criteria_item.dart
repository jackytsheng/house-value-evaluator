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
  String criteriaId = Uuid().v4();
  String criteriaName;
  double weighting;
  List<NoteItem> comments;

  CriteriaItemEntity(this.comments, this.criteriaName, this.weighting);
}
