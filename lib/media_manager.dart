import 'package:flutter/material.dart';

enum MediaType { photo, video }

class MediaItem {
  final String? url;
  final String? assetPath;
  final String? thumbnailPath;
  final String title;
  final String caption;
  final MediaType type;
  final String emoji;

  MediaItem({
    this.url,
    this.assetPath,
    this.thumbnailPath,
    required this.title,
    required this.caption,
    required this.type,
    required this.emoji,
  });

  bool get isAsset => assetPath != null;
}

class MediaManager {
  static final List<MediaItem> memories = [
    // ========================================
    // PHOTOS (bundled in app - work offline)
    // ========================================
    MediaItem(
      assetPath: 'assets/images/photo1.jpg',
      title: 'Drawing Day',
      caption: 'the day you gave me the drawing',
      type: MediaType.photo,
      emoji: '✨',
    ),
    MediaItem(
      assetPath: 'assets/images/photo2.jpg',
      title: 'Metro Moment',
      caption: 'metro moment - i ran away cuz i was about to cry lmao',
      type: MediaType.photo,
      emoji: '🚇',
    ),
    MediaItem(
      assetPath: 'assets/images/photo3.jpg',
      title: 'Bracelets',
      caption: 'bracelets. keychain. everything.',
      type: MediaType.photo,
      emoji: '💝',
    ),
    MediaItem(
      assetPath: 'assets/images/photo4.jpg',
      title: 'Random Moment',
      caption: 'just another moment i treasured',
      type: MediaType.photo,
      emoji: '💭',
    ),
    MediaItem(
      assetPath: 'assets/images/photo5.jpg',
      title: 'School Days',
      caption: 'remember this?',
      type: MediaType.photo,
      emoji: '📚',
    ),

    // ========================================
    // VIDEOS (Google Drive - stream online)
    // ========================================
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1dyVl54f1UY8paUHXbuUrrM-qFhlqDHVY',
      thumbnailPath: 'assets/images/thumbnails/video1_thumb.jpg',
      title: 'Concert Night',
      caption: 'concert clips - the best night ever',
      type: MediaType.video,
      emoji: '🎵',
    ),
    MediaItem(
      url: 'https://drive.google.com/uc?export=download&id=YOUR_FILE_ID_2',
      thumbnailPath: 'assets/images/thumbnails/video2_thumb.jpg',
      title: 'Roblox Nights',
      caption: 'goofy ahh roblox nights together',
      type: MediaType.video,
      emoji: '🎮',
    ),
    MediaItem(
      url: 'https://drive.google.com/uc?export=download&id=YOUR_FILE_ID_3',
      thumbnailPath: 'assets/images/thumbnails/video3_thumb.jpg',
      title: 'Metro Day',
      caption: 'that day on the metro',
      type: MediaType.video,
      emoji: '🚆',
    ),
    MediaItem(
      url: 'https://drive.google.com/uc?export=download&id=YOUR_FILE_ID_4',
      thumbnailPath: 'assets/images/thumbnails/video4_thumb.jpg',
      title: 'Random Clips',
      caption: 'random moments compilation',
      type: MediaType.video,
      emoji: '🎬',
    ),
  ];
}
