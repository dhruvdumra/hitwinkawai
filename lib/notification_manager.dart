import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================
// NOTIFICATION MODEL
// ============================================

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'receivedAt': receivedAt.toIso8601String(),
        'isRead': isRead,
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        receivedAt: json['receivedAt'] is Timestamp
            ? (json['receivedAt'] as Timestamp).toDate()
            : DateTime.tryParse(json['receivedAt'] ?? '') ?? DateTime.now(),
        isRead: json['isRead'] ?? false,
      );
}

// ============================================
// NOTIFICATION MANAGER (Singleton)
// Firestore = source of truth (works even if app is closed)
// SharedPreferences = read status cache only
// ============================================

class NotificationManager extends ChangeNotifier {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  static const _readCacheKey = 'read_notification_ids';

  List<AppNotification> _notifications = [];
  Set<String> _readIds = {};

  final _firestore = FirebaseFirestore.instance;
  // All notifications live in this Firestore collection
  // Collection path: notifications/
  // Each doc has: title, body, receivedAt (Timestamp), id
  static const _collection = 'notifications';

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // ── Load: fetch from Firestore + merge local read status ──
  Future<void> load() async {
    await _loadReadCache();
    await _fetchFromFirestore();
  }

  Future<void> _loadReadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_readCacheKey) ?? [];
      _readIds = raw.toSet();
    } catch (e) {
      debugPrint('NotificationManager: read cache load error: $e');
    }
  }

  Future<void> _saveReadCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_readCacheKey, _readIds.toList());
    } catch (e) {
      debugPrint('NotificationManager: read cache save error: $e');
    }
  }

  Future<void> _fetchFromFirestore() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('receivedAt', descending: true)
          .limit(50)
          .get();

      _notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        final notif = AppNotification.fromJson(data);
        notif.isRead = _readIds.contains(notif.id);
        return notif;
      }).toList();

      notifyListeners();
      debugPrint(
          '✅ Loaded ${_notifications.length} notifications from Firestore');
    } catch (e) {
      debugPrint('❌ Firestore fetch error: $e');
      // Fall back to local cache if Firestore fails
      await _loadFromLocalFallback();
    }
  }

  // ── Add: write to Firestore (used for foreground messages) ──
  Future<void> add(String title, String body) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'title': title,
        'body': body,
        'receivedAt': FieldValue.serverTimestamp(),
      });

      final notif = AppNotification(
        id: docRef.id,
        title: title,
        body: body,
        receivedAt: DateTime.now(),
      );

      _notifications.insert(0, notif);
      if (_notifications.length > 50) {
        _notifications = _notifications.sublist(0, 50);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Firestore add error: $e');
      // Still add locally if Firestore fails
      final notif = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        body: body,
        receivedAt: DateTime.now(),
      );
      _notifications.insert(0, notif);
      notifyListeners();
    }
  }

  // ── Mark all read (local only — no need to write to Firestore) ──
  Future<void> markAllRead() async {
    for (final n in _notifications) {
      n.isRead = true;
      _readIds.add(n.id);
    }
    await _saveReadCache();
    notifyListeners();
  }

  Future<void> markRead(String id) async {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      _readIds.add(id);
      await _saveReadCache();
      notifyListeners();
    }
  }

  // ── Delete: remove from Firestore ──
  Future<void> deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    _readIds.remove(id);
    notifyListeners();
    try {
      await _firestore.collection(_collection).doc(id).delete();
      await _saveReadCache();
    } catch (e) {
      debugPrint('❌ Firestore delete error: $e');
    }
  }

  // ── Clear all: delete entire collection ──
  Future<void> clearAll() async {
    _notifications.clear();
    _readIds.clear();
    notifyListeners();
    try {
      final batch = _firestore.batch();
      final snapshot = await _firestore.collection(_collection).get();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      await _saveReadCache();
    } catch (e) {
      debugPrint('❌ Firestore clear error: $e');
    }
  }

  // ── Refresh: re-fetch from Firestore ──
  Future<void> refresh() async {
    await _fetchFromFirestore();
  }

  // ── Local fallback (SharedPreferences) if Firestore is unreachable ──
  static const _localFallbackKey = 'notifications_local_fallback';

  Future<void> _saveLocalFallback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localFallbackKey,
        jsonEncode(_notifications.map((n) => n.toJson()).toList()),
      );
    } catch (_) {}
  }

  Future<void> _loadFromLocalFallback() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localFallbackKey);
      if (raw != null) {
        final List decoded = jsonDecode(raw);
        _notifications = decoded
            .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final n in _notifications) {
          n.isRead = _readIds.contains(n.id);
        }
        notifyListeners();
        debugPrint(
            '⚠️ Loaded ${_notifications.length} notifications from local fallback');
      }
    } catch (_) {}
  }
}
