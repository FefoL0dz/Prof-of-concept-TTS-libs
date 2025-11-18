import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../models.dart';
import '../tts_provider.dart';
import 'http_proxy_provider.dart';
import 'provider_utils.dart';

class CoquiServerProvider extends HttpProxyTtsProvider {
  CoquiServerProvider({Uri? endpoint})
      : super(
          id: 'coqui_server',
          displayName: 'Coqui/Piper Server',
          endpoint: endpoint ?? parseEnvUri('COQUI_ENDPOINT'),
        );

  @override
  bool get isAvailable => endpoint != null;

  @override
  Future<List<TtsVoice>> listVoices() async => const [
        TtsVoice(
          providerId: 'coqui_server',
          voiceId: 'pt-br-piper',
          name: 'Piper pt-BR',
          languageCode: 'pt-BR',
          isNeural: true,
        ),
      ];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}

class EmbeddedPiperProvider extends TtsProvider {
  EmbeddedPiperProvider()
      : super(id: 'embedded_piper', displayName: 'Embedded Piper', offline: true);

  static const MethodChannel _channel = MethodChannel('embedded_piper');
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    // Plugin-specific initialization should happen on the native side.
    _initialized = true;
  }

  @override
  bool get isAvailable => _initialized;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) async {
    if (!_initialized) {
      throw StateError('Embedded Piper is not initialized.');
    }
    final result = await _channel.invokeMethod<Uint8List>('synthesize', {
      'text': request.text,
      'voiceId': request.voice.voiceId,
      'languageCode': request.voice.languageCode,
    });
    if (result == null) {
      throw PlatformException(
        code: 'embedded-piper-unavailable',
        message: 'No audio returned from embedded Piper engine.',
      );
    }
    return result;
  }
}

class MaryTtsProvider extends HttpProxyTtsProvider {
  MaryTtsProvider({Uri? endpoint})
      : super(
          id: 'mary_tts',
          displayName: 'MaryTTS Server',
          endpoint: endpoint ?? parseEnvUri('MARYTTS_ENDPOINT'),
        );

  @override
  bool get isAvailable => endpoint != null;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}

class EspeakProvider extends HttpProxyTtsProvider {
  EspeakProvider({Uri? endpoint})
      : super(
          id: 'espeak',
          displayName: 'eSpeak NG Server',
          endpoint: endpoint ?? parseEnvUri('ESPEAK_ENDPOINT'),
          offline: true,
        );

  @override
  bool get isAvailable => endpoint != null;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}

class FestivalProvider extends HttpProxyTtsProvider {
  FestivalProvider({Uri? endpoint})
      : super(
          id: 'festival',
          displayName: 'Festival/Flite Server',
          endpoint: endpoint ?? parseEnvUri('FESTIVAL_ENDPOINT'),
          offline: true,
        );

  @override
  bool get isAvailable => endpoint != null;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}
