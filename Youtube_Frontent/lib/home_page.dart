import 'package:flutter/material.dart';
import 'models.dart';
import 'video_service.dart';
import 'video_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Video>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _videosFuture = VideoService.getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/YouTube_Logo_2017.svg/512px-YouTube_Logo_2017.svg.png',
          height: 24,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              'https://randomuser.me/api/portraits/men/32.jpg',
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 12),
                _buildChip('All', selected: true),
                _buildChip('Flutter'),
                _buildChip('Dart'),
                _buildChip('Mobile Development'),
                _buildChip('Web Development'),
                _buildChip('UI Design'),
                _buildChip('Firebase'),
                _buildChip('Supabase'),
                const SizedBox(width: 12),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Videos
          Expanded(
            child: FutureBuilder<List<Video>>(
              future: _videosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No videos found'));
                }
                
                final videos = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _videosFuture = VideoService.getVideos();
                    });
                  },
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return VideoCard(video: videos[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? Colors.black : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

