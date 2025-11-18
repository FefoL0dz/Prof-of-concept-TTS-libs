import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models.dart';
import '../tts_provider.dart';

/// Wraps the default platform TTS engines (Siri/Google system voices).
class DeviceTtsProvider extends TtsProvider {
  DeviceTtsProvider() : super(id: 'device', displayName: 'Device Voices', offline: true);

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  List<TtsVoice> _voices = const [];

  @override
  Future<void> initialize() async {
    await _tts.awaitSpeakCompletion(true);
    final dynamic rawVoices = await _tts.getVoices;
    if (rawVoices is List) {
      _voices = rawVoices
          .whereType<Map<dynamic, dynamic>>()
          .map((raw) => TtsVoice(
                providerId: id,
                voiceId: raw['name']?.toString() ?? 'unknown',
                name: raw['name']?.toString() ?? 'Unknown voice',
                languageCode: raw['locale']?.toString() ?? 'und',
                gender: raw['gender']?.toString(),
                isOffline: true,
              ))
          .where(
            (voice) => const ['pt-BR', 'es-ES', 'es-US', 'en-US', 'it-IT', 'fr-FR']
                .any((lang) => voice.languageCode.startsWith(lang.split('-').first)),
          )
          .toList(growable: false);
    }
    _initialized = true;
  }

  @override
  bool get isAvailable => _initialized && _voices.isNotEmpty;

  @override
  Future<List<TtsVoice>> listVoices() async => _voices;

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) {
    // The FlutterTts plugin streams audio directly to the platform engine, so
    // returning bytes is not supported without temporary files. Throwing here
    // makes it explicit for the registry/UI to handle playback differently.
    throw PlatformException(
      code: 'device-provider-streams-audio',
      message: 'Device provider plays audio directly; cannot return bytes.',
    );
  }
}

/// Android-only provider that uses the SherpaTTS engine (Piper models) when installed.
class SherpaTtsProvider extends TtsProvider {
  SherpaTtsProvider()
      : super(id: 'sherpa', displayName: 'SherpaTTS (Offline Neural)', offline: true);

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  static const MethodChannel _channel = MethodChannel('sherpa_tts');

  @override
  Future<void> initialize() async {
    // Attempt to switch to Sherpa if available. This requires calling a platform
    // channel; for now we optimistically assume the user set it as default.
    await _tts.awaitSpeakCompletion(true);
    _initialized = true;
  }

  @override
  bool get isAvailable => _initialized;

  @override
  Future<List<TtsVoice>> listVoices() async {
    final dynamic rawVoices = await _tts.getVoices;
    if (rawVoices is! List) return const [];
    return rawVoices
        .whereType<Map<dynamic, dynamic>>()
        .map((raw) => TtsVoice(
              providerId: id,
              voiceId: raw['name']?.toString() ?? 'unknown',
              name: raw['name']?.toString() ?? 'Unknown voice',
              languageCode: raw['locale']?.toString() ?? 'und',
              gender: raw['gender']?.toString(),
              isOffline: true,
              isNeural: true,
            ))
        .toList(growable: false);
  }

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) async {
    if (!_initialized) {
      throw StateError('SherpaTTS not initialized.');
    }
    final result = await _channel.invokeMethod<Uint8List>('synthesize', {
      'text': request.text,
      'voiceId': request.voice.voiceId,
      'languageCode': request.voice.languageCode,
    });
    if (result == null) {
      throw PlatformException(
        code: 'sherpa-provider-streams-audio',
        message: 'SherpaTTS channel returned no audio bytes.',
      );
    }
    return result;
  }
}
