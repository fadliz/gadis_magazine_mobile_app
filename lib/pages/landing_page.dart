import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../pages/show_article_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constant.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  List<dynamic> _articles = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    final response = await http.get(Uri.parse('${articlesURL}/latest'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        _articles = data['articles'];
      });
    } else {
      // Handle error
      print('Failed to fetch articles');
    }
  }

  String truncateTitle(String title, {int maxLength = 20}) {
    return (title.length > maxLength)
        ? '${title.substring(0, maxLength)}...'
        : title;
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
            const Center(
              child: Text(
                'Top 3 Most View Article',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 24,
                  fontVariations: [FontVariation('wght', 700)],
                ),
              ),
            ),
            const SizedBox(height: 32), // Space between the text and the first card
            Expanded(
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  final category = article['category'];
                  final title = article['title'];
                  final content = article['content'];
                  final author = article['author'];
                  final id = article['id'];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Space between cards
                    child: GestureDetector(
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
                                '$baseURL/storage/${article['image']}',
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
                                  height:
                                      8), // Adding space between content and author
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
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 193,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    // Redirect to '/articles' or call ArticlesPage()
                    Navigator.pushNamed(context,
                        '/articles'); // Assuming you've defined '/articles' in your routes
                    // Alternatively, you can call the function directly:
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticlesPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pink,
                    side: const BorderSide(color: Colors.pink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('See All'),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
