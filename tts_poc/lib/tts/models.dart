import 'package:flutter/foundation.dart';

/// Represents a single voice across providers with normalized metadata.
class TtsVoice {
  const TtsVoice({
    required this.providerId,
    required this.voiceId,
    required this.name,
    required this.languageCode,
    this.gender,
    this.isOffline = false,
    this.isNeural = false,
    this.supportedStyles = const <TtsStyle>[],
  });

  final String providerId;
  final String voiceId;
  final String name;
  final String languageCode;
  final String? gender;
  final bool isOffline;
  final bool isNeural;
  final List<TtsStyle> supportedStyles;

  @override
  String toString() {
    return 'TtsVoice(provider: $providerId, id: $voiceId, lang: $languageCode, name: $name)';
  }
}

/// Represents optional style/emotion/performance configs.
class TtsStyle {
  const TtsStyle({required this.id, required this.displayName});

  final String id;
  final String displayName;
}

/// Helper describing synthesis input.
@immutable
class TtsSynthesisRequest {
  const TtsSynthesisRequest({
    required this.text,
    required this.voice,
    this.style,
  });

  final String text;
  final TtsVoice voice;
  final TtsStyle? style;
}
