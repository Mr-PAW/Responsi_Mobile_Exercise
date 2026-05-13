import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final String id;
  final String menuType;
  final String appBarTitle;

  DetailPage({
    required this.id,
    required this.menuType,
    required this.appBarTitle,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? detailData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final response = await http.get(
      Uri.parse(
        'https://api.spaceflightnewsapi.net/v4/${widget.menuType}/${widget.id}/',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        detailData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Gagal load detail');
    }
  }

  Future<void> _launchURL() async {
    if (detailData != null && detailData!['url'] != null) {
      final Uri url = Uri.parse(detailData!['url']);
      if (!await launchUrl(url)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tidak dapat membuka link')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(
          '${widget.appBarTitle} Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xFF2C2C2C),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.grey[400]))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      detailData!['image_url'] ?? '',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    detailData!['title'] ?? 'No Title',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Published At: ${detailData!['published_at'] != null ? detailData!['published_at'].substring(0, 10) : '-'}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    detailData!['summary'] ?? 'No summary available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.blueGrey[700],
              onPressed: _launchURL,
              child: Icon(Icons.public, color: Colors.white),
              tooltip: 'Buka di Web',
            ),
    );
  }
}
