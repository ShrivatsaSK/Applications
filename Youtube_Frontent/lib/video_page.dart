import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models.dart';
import 'video_service.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  Video? _video;
  bool _isLoading = true;
  bool _isLiked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final videoId = ModalRoute.of(context)?.settings.arguments as String?;
    if (videoId != null) {
      _loadVideo(videoId);
    }
  }

  Future<void> _loadVideo(String videoId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final video = await VideoService.getVideoById(videoId);
      setState(() {
        _video = video;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (_video == null) return;

    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _video!.likes++;
      } else {
        _video!.likes--;
      }
    });

    await VideoService.updateLikes(_video!.id, _video!.likes);
  }

  Future<void> _addComment() async {
    if (_video == null) return;

    // In a real app, you would show a comment dialog
    // For this demo, we'll just increment the comment count
    setState(() {
      _video!.comments++;
    });

    await VideoService.updateComments(_video!.id, _video!.comments);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_video == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Video not found')),
        body: const Center(child: Text('Could not load the video')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  Image.network(
                    _video!.thumbnailUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.play_circle_fill,
                        size: 60,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // In a real app, this would play the video
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Playing video...')),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            
            // Video info
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _video!.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_video!.views} • ${_video!.uploadTime}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          
                          // Action buttons
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildActionButton(
                                icon: _isLiked 
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                label: _formatCount(_video!.likes),
                                onTap: _toggleLike,
                                isActive: _isLiked,
                              ),
                              _buildActionButton(
                                icon: Icons.thumb_down_outlined,
                                label: 'Dislike',
                                onTap: () {},
                              ),
                              _buildActionButton(
                                icon: Icons.comment_outlined,
                                label: _formatCount(_video!.comments),
                                onTap: _addComment,
                              ),
                              _buildActionButton(
                                icon: Icons.share_outlined,
                                label: 'Share',
                                onTap: () {},
                              ),
                              _buildActionButton(
                                icon: Icons.download_outlined,
                                label: 'Download',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const Divider(),
                    
                    // Channel info
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(_video!.channelAvatarUrl),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _video!.channelName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '1.2M subscribers',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('SUBSCRIBE'),
                          ),
                        ],
                      ),
                    ),
                    
                    const Divider(),
                    
                    // Comments
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comments • ${_formatCount(_video!.comments)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Comment input
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  'https://randomuser.me/api/portraits/men/32.jpg',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onTap: _addComment,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Sample comments
                          _buildCommentItem(
                            username: 'John Doe',
                            avatar: 'https://randomuser.me/api/portraits/men/43.jpg',
                            comment: 'This is such a great tutorial! I learned a lot about Flutter and Supabase integration.',
                            time: '2 days ago',
                            likes: '45',
                          ),
                          
                          _buildCommentItem(
                            username: 'Jane Smith',
                            avatar: 'https://randomuser.me/api/portraits/women/22.jpg',
                            comment: 'Could you make a follow-up video on how to implement authentication with Supabase?',
                            time: '1 week ago',
                            likes: '12',
                          ),
                          
                          _buildCommentItem(
                            username: 'Alex Johnson',
                            avatar: 'https://randomuser.me/api/portraits/men/91.jpg',
                            comment: 'I\'m having an issue with the database connection. Can anyone help?',
                            time: '3 days ago',
                            likes: '8',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : null,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem({
    required String username,
    required String avatar,
    required String comment,
    required String time,
    required String likes,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(likes),
                    const SizedBox(width: 16),
                    const Icon(Icons.thumb_down_outlined, size: 16),
                    const Spacer(),
                    const Text(
                      'REPLY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    } else {
      return count.toString();
    }
  }
}

