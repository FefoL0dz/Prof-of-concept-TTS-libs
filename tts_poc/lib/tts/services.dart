import 'dart:collection';
import 'dart:typed_data';

import 'models.dart';

/// Extremely simple in-memory cache to avoid re-synthesizing identical text/voice combos.
class AudioCacheService {
  final Map<String, Uint8List> _memoryCache = HashMap();

  String cacheKey(TtsSynthesisRequest request) {
    final buffer = StringBuffer()
      ..write(request.voice.providerId)
      ..write('|')
      ..write(request.voice.voiceId)
      ..write('|')
      ..write(request.style?.id ?? 'default')
      ..write('|')
      ..write(request.text);
    return buffer.toString();
  }

  Uint8List? get(TtsSynthesisRequest request) => _memoryCache[cacheKey(request)];

  void save(TtsSynthesisRequest request, Uint8List bytes) {
    _memoryCache[cacheKey(request)] = bytes;
  }
}

/// Tracks free-tier usage per provider so we can rotate automatically once a quota is exhausted.
class QuotaTracker {
  final Map<String, int> _usageByProvider = {};
  final Map<String, int> _limits = {};

  void setLimit(String providerId, int characters) {
    _limits[providerId] = characters;
  }

  void recordUsage(String providerId, int characters) {
    _usageByProvider.update(providerId, (value) => value + characters, ifAbsent: () => characters);
  }

  bool hasQuota(String providerId) {
    final limit = _limits[providerId];
    if (limit == null) return true;
    final used = _usageByProvider[providerId] ?? 0;
    return used < limit;
  }
}
