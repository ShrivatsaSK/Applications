class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelName;
  final String channelAvatarUrl;
  final String duration;
  final String uploadTime;
  final String views;
  int likes;
  int comments;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.channelName,
    required this.channelAvatarUrl,
    required this.duration,
    required this.uploadTime,
    required this.views,
    required this.likes,
    required this.comments,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      channelName: json['channel_name'] as String,
      channelAvatarUrl: json['channel_avatar_url'] as String,
      duration: json['duration'] as String,
      uploadTime: json['upload_time'] as String,
      views: json['views'] as String,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_url': thumbnailUrl,
      'channel_name': channelName,
      'channel_avatar_url': channelAvatarUrl,
      'duration': duration,
      'upload_time': uploadTime,
      'views': views,
      'likes': likes,
      'comments': comments,
    };
  }
}

