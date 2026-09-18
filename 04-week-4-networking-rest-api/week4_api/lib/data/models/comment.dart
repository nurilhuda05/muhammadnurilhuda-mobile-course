class Comment {
  const Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  /// Constructor fromJson yang aman dari null.
  /// Jika tipe data tidak sesuai atau bernilai null, maka akan diberikan nilai default.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: num.tryParse(json['postId']?.toString() ?? '')?.toInt() ?? 0,
      id: num.tryParse(json['id']?.toString() ?? '')?.toInt() ?? 0,
      name: json['name']?.toString() ?? '', // Safe conversion ke string
      email: json['email']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  /// Konversi object ke JSON Map.
  Map<String, dynamic> toJson() => {
        'postId': postId,
        'id': id,
        'name': name,
        'email': email,
        'body': body,
      };
}
