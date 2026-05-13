import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail_page.dart';

class ListPage extends StatefulWidget {
  final String menuType; 
  final String appBarTitle; 

  ListPage({required this.menuType, required this.appBarTitle});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse('https://api.spaceflightnewsapi.net/v4/${widget.menuType}/'),
    );

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body)['results'];
        isLoading = false;
      });
    } else {
      throw Exception('Gagal load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF2C2C2C),
        iconTheme: IconThemeData(
          color: Colors.white,
        ), 
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.grey[400]))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  color: Color(0xFF2C2C2C),
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            id: item['id'].toString(),
                            menuType: widget.menuType,
                            appBarTitle: widget.appBarTitle,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                          child: Image.network(
                            item['image_url'] ?? '',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey[800],
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? 'No Title',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  item['summary'] ?? '',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
