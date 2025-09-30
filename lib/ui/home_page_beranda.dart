import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka URL di browser

class HomePageBeranda extends StatelessWidget {
  const HomePageBeranda();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Banner Gambar
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/banner_image.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Banner", // Judul banner
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Spasi setelah banner
              // Daftar Artikel
              Text(
                "Artikel",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ListView(
                shrinkWrap: true, // Agar ListView tidak mempengaruhi scroll utama
                physics: NeverScrollableScrollPhysics(), // Agar tidak ada scrolling di dalam ListView
                children: [
                  _ArticleCard(
                    title: "Judul Artikel 1",
                    description: "Slug Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    url: "https://www.example.com/article1",
                  ),
                  _ArticleCard(
                    title: "Judul Artikel 2",
                    description: "Slug Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    url: "https://www.example.com/article2",
                  ),
                  _ArticleCard(
                    title: "Judul Artikel 3",
                    description: "Slug Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    url: "https://www.example.com/article3",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan setiap artikel
class _ArticleCard extends StatelessWidget {
  final String title;
  final String description;
  final String url;

  const _ArticleCard({
    required this.title,
    required this.description,
    required this.url,
  });

  // Fungsi untuk membuka artikel di browser
  void _openArticle(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => _openArticle(url), // Membuka artikel di browser
      ),
    );
  }
}
