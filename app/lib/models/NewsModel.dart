class Article {
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;

  Article({
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: DateTime.parse(json['publishedAt']).toLocal().toString(),
    );
  }
}
