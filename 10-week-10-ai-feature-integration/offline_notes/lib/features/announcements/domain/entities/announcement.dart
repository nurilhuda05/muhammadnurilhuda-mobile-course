class Announcement {
  const Announcement({
    this.id,
    required this.title,
    this.content = '',
    required this.createdAt,
  });

  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;
}
