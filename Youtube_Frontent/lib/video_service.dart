import 'package:flutter/material.dart';
import 'main.dart';
import 'models.dart';

class VideoService {
  // Sample data for videos
  static List<Video> sampleVideos = [
    Video(
      id: '1',
      title: 'Flutter Tutorial for Beginners - Build iOS and Android Apps',
      thumbnailUrl: 'https://i.ytimg.com/vi/1ukSR1GRtMU/maxresdefault.jpg',
      channelName: 'Academind',
      channelAvatarUrl: 'https://yt3.googleusercontent.com/ytc/APkrFKaqca-xQcJtp9tQAK5QgBRNZJN-gBLGoUUW9ybf=s176-c-k-c0x00ffffff-no-rj',
      duration: '1:25:36',
      uploadTime: '2 weeks ago',
      views: '1.2M views',
      likes: 45000,
      comments: 1200,
    ),
    Video(
      id: '2',
      title: 'Learn Dart Programming in 2 Hours - Full Crash Course',
      thumbnailUrl: 'https://i.ytimg.com/vi/5rtujDjt50I/maxresdefault.jpg',
      channelName: 'Flutter Mapp',
      channelAvatarUrl: 'https://yt3.googleusercontent.com/ytc/APkrFKYzQtD3JBT6AqOqz_7_BPyxBNJGKu9i2B0S8oo-=s176-c-k-c0x00ffffff-no-rj',
      duration: '2:05:10',
      uploadTime: '3 days ago',
      views: '450K views',
      likes: 18000,
      comments: 520,
    ),
    Video(
      id: '3',
      title: 'Build a Complete App with Supabase and Flutter',
      thumbnailUrl: 'https://i.ytimg.com/vi/Y47n-8H8lAA/maxresdefault.jpg',
      channelName: 'Flutter',
      channelAvatarUrl: 'https://yt3.googleusercontent.com/ytc/APkrFKZJdGQNLMJg9d6PLeJUTRWeOAZcBTlCiLjL7Tvw=s176-c-k-c0x00ffffff-no-rj',
      duration: '45:22',
      uploadTime: '1 month ago',
      views: '320K views',
      likes: 12000,
      comments: 350,
    ),
    Video(
      id: '4',
      title: 'Responsive UI in Flutter - Mobile, Tablet, and Web',
      thumbnailUrl: 'https://i.ytimg.com/vi/C6fwOQIw8U8/maxresdefault.jpg',
      channelName: 'Code With Andrea',
      channelAvatarUrl: 'https://yt3.googleusercontent.com/ytc/APkrFKZWeMCsx4Q9e_Hm6nhOOUQ3fv96QGUXiMr1-pPP=s176-c-k-c0x00ffffff-no-rj',
      duration: '32:15',
      uploadTime: '5 days ago',
      views: '180K views',
      likes: 8500,
      comments: 210,
    ),
    Video(
      id: '5',
      title: 'State Management in Flutter - Provider vs Bloc vs Riverpod',
      thumbnailUrl: 'https://i.ytimg.com/vi/3tm-R7ymwhc/maxresdefault.jpg',
      channelName: 'Flutter Explained',
      channelAvatarUrl: 'https://yt3.googleusercontent.com/ytc/APkrFKbL9CUNPd5m7RQvqQOFCUEgwyD2Z9TMSJMsxSrg=s176-c-k-c0x00ffffff-no-rj',
      duration: '58:42',
      uploadTime: '2 months ago',
      views: '275K views',
      likes: 15000,
      comments: 480,
    ),
  ];

  // Get all videos
  static Future<List<Video>> getVideos() async {
    try {
      // First try to get videos from Supabase
      final response = await supabase
          .from('videos')
          .select()
          .order('id', ascending: true);
      
      if (response.isNotEmpty) {
        return response.map((video) => Video.fromJson(video)).toList();
      } else {
        // If no videos in Supabase, return sample videos
        return sampleVideos;
      }
    } catch (e) {
      debugPrint('Error fetching videos: $e');
      // Return sample videos if there's an error
      return sampleVideos;
    }
  }

  // Search videos
  static Future<List<Video>> searchVideos(String query) async {
    try {
      // Try to search videos from Supabase
      final response = await supabase
          .from('videos')
          .select()
          .ilike('title', '%$query%')
          .order('id', ascending: true);
      
      if (response.isNotEmpty) {
        return response.map((video) => Video.fromJson(video)).toList();
      } else {
        // If no videos in Supabase, search sample videos
        return sampleVideos
            .where((video) => video.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    } catch (e) {
      debugPrint('Error searching videos: $e');
      // Search sample videos if there's an error
      return sampleVideos
          .where((video) => video.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Update likes
  static Future<bool> updateLikes(String videoId, int likes) async {
    try {
      await supabase
          .from('videos')
          .update({'likes': likes})
          .eq('id', videoId);
      return true;
    } catch (e) {
      debugPrint('Error updating likes: $e');
      // For sample data, update locally
      final videoIndex = sampleVideos.indexWhere((v) => v.id == videoId);
      if (videoIndex != -1) {
        sampleVideos[videoIndex].likes = likes;
      }
      return false;
    }
  }

  // Update comments
  static Future<bool> updateComments(String videoId, int comments) async {
    try {
      await supabase
          .from('videos')
          .update({'comments': comments})
          .eq('id', videoId);
      return true;
    } catch (e) {
      debugPrint('Error updating comments: $e');
      // For sample data, update locally
      final videoIndex = sampleVideos.indexWhere((v) => v.id == videoId);
      if (videoIndex != -1) {
        sampleVideos[videoIndex].comments = comments;
      }
      return false;
    }
  }

  // Get video by ID
  static Future<Video?> getVideoById(String id) async {
    try {
      final response = await supabase
          .from('videos')
          .select()
          .eq('id', id)
          .single();
      
      return Video.fromJson(response);
    } catch (e) {
      debugPrint('Error fetching video: $e');
      // Return sample video if there's an error
      return sampleVideos.firstWhere((v) => v.id == id, orElse: () => sampleVideos.first);
    }
  }
}

