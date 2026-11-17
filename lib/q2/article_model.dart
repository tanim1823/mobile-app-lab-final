class Article {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Article({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json['id'] as int,
    userId: json['userId'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
  );
}