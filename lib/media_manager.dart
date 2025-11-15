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
      title: 'drawinggg',
      caption: 'drawing and bracelet that ill always treasure omg',
      type: MediaType.photo,
      emoji: '✨',
    ),
    MediaItem(
      assetPath: 'assets/images/photo2.jpg',
      title: 'HEHEHEHHEHE',
      caption: 'PHOTOTOOTSHOOOOOT',
      type: MediaType.photo,
      emoji: '📷',
    ),
    MediaItem(
      assetPath: 'assets/images/photo3.jpg',
      title: 'WWWWWWWWW',
      caption: 'sigma twins',
      type: MediaType.photo,
      emoji: '🔥',
    ),
    MediaItem(
      assetPath: 'assets/images/photo4.jpg',
      title: 'hehehehehheheh',
      caption: 'WWW TWIBS',
      type: MediaType.photo,
      emoji: '🔋',
    ),
    MediaItem(
      assetPath: 'assets/images/photo5.jpg',
      title: 'ayayayyayayayyaya',
      caption: 'SLAYYYYY TWINS',
      type: MediaType.photo,
      emoji: '💅',
    ),
    MediaItem(
      assetPath: 'assets/images/photo6.jpg',
      title: 'silly :3',
      caption: 'roblox jumpers ahh :3',
      type: MediaType.photo,
      emoji: '😛',
    ),
    // ========================================
    // VIDEOS (Google Drive - stream online)
    // ========================================
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1nmMWMRaFfO9OawO3pFfHWuekDtKi2c55',
      thumbnailPath: 'assets/images/thumbnails/video0_thumb.jpg',
      title: ':)))))))))))))))',
      caption: 'twink alert',
      type: MediaType.video,
      emoji: '🎵',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1dyVl54f1UY8paUHXbuUrrM-qFhlqDHVY',
      thumbnailPath: 'assets/images/thumbnails/video1_thumb.jpg',
      title: 'indian idol winner',
      caption: 'roblox w singing by wini part 1',
      type: MediaType.video,
      emoji: '🎵',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1HidIBZ4ixDsQECpGD762K-LA1CMzYxnY',
      thumbnailPath: 'assets/images/thumbnails/video2_thumb.jpg',
      title: 'indian idol winner',
      caption: 'roblox w singing by wini part 2',
      type: MediaType.video,
      emoji: '🎮',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1xz4A4p3LhLcrCjn54_SxtRshCt2PFxOO',
      thumbnailPath: 'assets/images/thumbnails/video3_thumb.jpg',
      title: 'adopted kids',
      caption: 'this isnt you oni chan 😨😨😔😱😱💀',
      type: MediaType.video,
      emoji: '🔥',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1ECgFqswEb51MoKw5W67naA3bI5pA_6bZ',
      thumbnailPath: 'assets/images/thumbnails/video4_thumb.jpg',
      title: 'photophotophoto',
      caption: 'wowowowoowowowowo WW',
      type: MediaType.video,
      emoji: '🎬',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1znpTgI4wNbBZuuz-sd1paGx9cXrM2Y13',
      thumbnailPath: 'assets/images/thumbnails/video5_thumb.jpg',
      title: 'yayayayyayayyaya',
      caption: 'goofy and silly twib',
      type: MediaType.video,
      emoji: '✨',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1tsFzuBHcQ0qooacevuyiV-CdI0jZfrIz',
      thumbnailPath: 'assets/images/thumbnails/video6_thumb.jpg',
      title: 'phototo',
      caption: 'photoshoot WWW',
      type: MediaType.video,
      emoji: '🔋',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1nUgukFFHzQiZ61Idjku0Y24lu3ucP-B3',
      thumbnailPath: 'assets/images/thumbnails/video7_thumb.jpg',
      title: 'wowoowowow silly soo',
      caption: 'sigma sigma on the wall',
      type: MediaType.video,
      emoji: '🙂',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1ayAC0CIJUirAZL2Ssc1ahQbdjGsPHOw5',
      thumbnailPath: 'assets/images/thumbnails/video8_thumb.jpg',
      title: 'wowoowowow silly soo yayayyaa',
      caption: 'whos the skibidest of them all w wini',
      type: MediaType.video,
      emoji: '🩸',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1SBvhPQtlVhNhGKbmcVgSsfYmrv_IuYRw',
      thumbnailPath: 'assets/images/thumbnails/video9_thumb.jpg',
      title: 'w singer w wini',
      caption: 'dav jai jai dav jai jai',
      type: MediaType.video,
      emoji: '🌟',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1N3e46MMMhOrOnW88r7aG2AMk1oUIUY0x',
      thumbnailPath: 'assets/images/thumbnails/video10_thumb.jpg',
      title: 'dance india dance',
      caption: 'the whole gc dance wow griddy sigma',
      type: MediaType.video,
      emoji: '🕺',
    ),
    MediaItem(
      url:
          'https://drive.google.com/uc?export=download&id=1DJrHARIdGKxv_YItd0hFJUYzB7H_VzF9',
      thumbnailPath: 'assets/images/thumbnails/video11_thumb.jpg',
      title: 'dance india dance',
      caption: 'the whole gc dances again tuff asl W',
      type: MediaType.video,
      emoji: '😛',
    ),
  ];
}
