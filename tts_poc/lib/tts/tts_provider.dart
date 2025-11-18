import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'models.dart';

/// Base contract for every TTS provider path described in the plan.
abstract class TtsProvider {
  const TtsProvider({required this.id, required this.displayName, this.offline = false});

  final String id;
  final String displayName;
  final bool offline;

  /// Providers should perform heavy setup (auth tokens, downloading voices, etc.) here.
  Future<void> initialize();

  /// List available voices filtered to pt-BR/ES/EN/IT/FR.
  Future<List<TtsVoice>> listVoices();

  /// Generate speech audio and return bytes (MP3/WAV) ready for playback.
  Future<Uint8List> synthesize(TtsSynthesisRequest request);

  /// Whether the provider currently has quota/permissions to synthesize.
  bool get isAvailable;
}

/// Registry that knows how to iterate over providers for fallback/selection logic.
class TtsProviderRegistry {
  TtsProviderRegistry(this.providers);

  final List<TtsProvider> providers;

  Future<void> initializeAll() async {
    for (final provider in providers) {
      try {
        await provider.initialize();
      } catch (err) {
        debugPrint('Provider \'${provider.id}\' failed to initialize: $err');
      }
    }
  }

  List<TtsProvider> get availableProviders =>
      providers.where((provider) => provider.isAvailable).toList(growable: false);
}
