import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../pages/show_article_page.dart';
import '../../constant.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key? key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  int _selectedIndex = 1;
  List<dynamic> _articles = [];
  int _currentPage = 1;
  bool _loading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchArticles() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    final response =
        await http.get(Uri.parse('$articlesURL?page=$_currentPage'));
    if (response.statusCode == 200) {
      setState(() {
        _articles.addAll(json.decode(response.body)['articles']['data']);
        _currentPage++;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      throw Exception('Failed to load articles');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchArticles();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on the index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF6F6),
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40, // Adjust the height to make the search bar thinner
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Something...',
                  hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xffb4b4b4)),
                  prefixIcon: SizedBox(
                    width: 32,
                    height: 32,
                    child: SvgPicture.asset('assets/icons/search.svg',
                        color: Colors.grey,
                        height: 5,
                        width: 5,
                        fit: BoxFit.scaleDown
                        // Set the desired color for the icon
                        ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xffe6e6e6),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xffe6e6e6),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _articles.length + 1, // Add 1 for loading indicator
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 32.0),
                      child: Center(
                        child: Text(
                          'Article',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 24,
                            fontVariations: [FontVariation('wght', 700)],
                          ),
                        ),
                      ),
                    );
                  } else if (index - 1 < _articles.length) {
                    final article = _articles[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ArticleCard(
                        category: article['category'],
                        title: article['title'],
                        content: article['content'],
                        author: article['author'],
                        image: article['image'],
                        id: article['id'],
                      ),
                    );
                  } else {
                    return _loading ? _buildLoadingIndicator() : Container();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

String truncateTitle(String title, {int maxLength = 20}) {
  return (title.length > maxLength)
      ? '${title.substring(0, maxLength)}...'
      : title;
}

class ArticleCard extends StatelessWidget {
  final String category;
  final String title;
  final String content;
  final String author;
  final String image;
  final int id;

  const ArticleCard({
    Key? key,
    required this.category,
    required this.title,
    required this.content,
    required this.author,
    required this.image,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowArticlePage(articleId: id),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(
            color: Color(0xffe6e6e6),
          ),
        ),
        child: ListTile(
          leading: SizedBox(
            width: 115, // Set the desired width
            height: 115, // Set the desired height
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.network(
                '$baseURL/storage/$image',
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 10,
                    fontVariations: [FontVariation('wght', 400)],
                    color: Colors.pink),
              ),
              const SizedBox(height: 4),
              Text(
                truncateTitle(title),
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontVariations: [FontVariation('wght', 600)]),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                content.length > 100
                    ? content.substring(0, 100) + '...'
                    : content,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontVariations: [FontVariation('wght', 400)],
                    color: Color(0xff6a6a6a)),
              ),
              const SizedBox(
                  height: 8), // Adding space between content and author
              Divider(),
              Text(
                'by $author',
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontVariations: [FontVariation('wght', 400)],
                    color: Color(0xff6a6a6a)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
