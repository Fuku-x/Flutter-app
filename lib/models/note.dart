class Note {
  final String id;
  String title;
  List<String> tags;
  String summary;
  DateTime date;
  String? folder;

  Note({
    required this.id,
    required this.title,
    required this.tags,
    required this.summary,
    required this.date,
    this.folder,
  });

  Note copyWith({
    String? id,
    String? title,
    List<String>? tags,
    String? summary,
    DateTime? date,
    String? folder,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      tags: tags ?? List.from(this.tags),
      summary: summary ?? this.summary,
      date: date ?? this.date,
      folder: folder ?? this.folder,
    );
  }
}
