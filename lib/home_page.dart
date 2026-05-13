import 'package:flutter/material.dart';
import 'list_page.dart';

class HomePage extends StatelessWidget {
  final String username;

  HomePage({required this.username});

  Widget _buildMenuCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      color: Color(0xFF2C2C2C),
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        
        onTap: () {
          
          String endpoint = '';
          if (title == 'NEWS')
            endpoint = 'articles';
          else if (title == 'BLOG')
            endpoint = 'blogs';
          else if (title == 'REPORT')
            endpoint = 'reports';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ListPage(menuType: endpoint, appBarTitle: title),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 50, color: Colors.grey[500]),
              ),
              SizedBox(width: 16),
             
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        title: Text(
          'Halo, $username!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF2C2C2C),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildMenuCard(
            context,
            'NEWS',
            'Temukan berita terbaru dan terkini seputar dunia penerbangan luar angkasa dan teknologi.',
            Icons.newspaper,
          ),
          _buildMenuCard(
            context,
            'BLOG',
            'Baca opini, artikel, dan cerita mendalam dari para ahli serta penggemar antariksa.',
            Icons.article,
          ),
          _buildMenuCard(
            context,
            'REPORT',
            'Laporan resmi dan data analitik mendetail terkait misi dan stasiun luar angkasa.',
            Icons.analytics,
          ),
        ],
      ),
    );
  }
}
