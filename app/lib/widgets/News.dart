import 'package:app/models/NewsModel.dart';
import 'package:app/providers/articles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  Future<void> _refreshArticles(BuildContext context) async {
    final provider = Provider.of<ArticlesProvider>(context, listen: false);
    await provider.fetchArticles(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticlesProvider>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          provider.fetchArticles();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('Noticias')),
      body: RefreshIndicator(
        onRefresh: () => _refreshArticles(context),
        child: provider.isLoading && provider.articles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                controller: _scrollController,
                itemCount: provider.articles.length,
                itemBuilder: (context, index) {
                  final article = provider.articles[index];
                  return ArticleCard(article: article);
                },
              ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMd().add_jm();
    final String formattedDate = formatter.format(DateTime.parse(article.publishedAt));

    return GestureDetector(
      onTap: () async {
        Uri url = Uri.parse(article.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                child: Image.network(
                  article.urlToImage!,
                  height: 400, // Ajusta la altura a pantalla completa
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
