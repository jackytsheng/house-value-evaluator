import 'package:uuid/uuid.dart';

class NoteItem {
  NoteItem({
    this.expandedValue = "",
    this.headerValue = "",
    this.isExpanded = false,
  });

  String noteId = const Uuid().v4();
  String expandedValue;
  String headerValue;
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
