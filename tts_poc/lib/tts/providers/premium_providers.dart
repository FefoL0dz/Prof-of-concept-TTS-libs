import '../models.dart';
import 'http_proxy_provider.dart';
import 'provider_utils.dart';

class ElevenLabsProvider extends HttpProxyTtsProvider {
  ElevenLabsProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('ELEVENLABS_API_KEY'),
        super(
          id: 'eleven_labs',
          displayName: 'ElevenLabs',
          endpoint: endpoint ?? parseEnvUri('ELEVENLABS_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('ELEVENLABS_API_KEY');
            return key.isEmpty ? <String, String>{} : {'xi-api-key': key};
          },
        );

  final String _apiKey;

  @override
  bool get isAvailable => endpoint != null && _apiKey.isNotEmpty;

  @override
  Future<List<TtsVoice>> listVoices() async => const [
        TtsVoice(
          providerId: 'eleven_labs',
          voiceId: 'eleven_ptbr',
          name: 'ElevenLabs pt-BR',
          languageCode: 'pt-BR',
          isNeural: true,
        ),
      ];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice_id': request.voice.voiceId,
        'language_code': request.voice.languageCode,
      };
}

class PlayHtProvider extends HttpProxyTtsProvider {
  PlayHtProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('PLAYHT_API_KEY'),
        super(
          id: 'play_ht',
          displayName: 'Play.ht',
          endpoint: endpoint ?? parseEnvUri('PLAYHT_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('PLAYHT_API_KEY');
            return key.isEmpty ? <String, String>{} : {'Authorization': key};
          },
        );

  final String _apiKey;

  @override
  bool get isAvailable => endpoint != null && _apiKey.isNotEmpty;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}

class MurfProvider extends HttpProxyTtsProvider {
  MurfProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('MURF_API_KEY'),
        super(
          id: 'murf',
          displayName: 'Murf.ai',
          endpoint: endpoint ?? parseEnvUri('MURF_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('MURF_API_KEY');
            return key.isEmpty ? <String, String>{} : {'X-API-Key': key};
          },
        );

  final String _apiKey;

  @override
  bool get isAvailable => endpoint != null && _apiKey.isNotEmpty;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}

class WellSaidProvider extends HttpProxyTtsProvider {
  WellSaidProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('WELLSAID_API_KEY'),
        super(
          id: 'well_said',
          displayName: 'WellSaid Labs',
          endpoint: endpoint ?? parseEnvUri('WELLSAID_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('WELLSAID_API_KEY');
            return key.isEmpty ? <String, String>{} : {'Authorization': 'Bearer $key'};
          },
        );

  final String _apiKey;

  @override
  bool get isAvailable => endpoint != null && _apiKey.isNotEmpty;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}

class ResembleProvider extends HttpProxyTtsProvider {
  ResembleProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('RESEMBLE_API_KEY'),
        super(
          id: 'resemble',
          displayName: 'Resemble AI',
          endpoint: endpoint ?? parseEnvUri('RESEMBLE_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('RESEMBLE_API_KEY');
            return key.isEmpty ? <String, String>{} : {'Authorization': 'Bearer $key'};
          },
        );

  final String _apiKey;

  @override
  bool get isAvailable => endpoint != null && _apiKey.isNotEmpty;

  @override
  Future<List<TtsVoice>> listVoices() async => const [];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voice': request.voice.voiceId,
        'language': request.voice.languageCode,
      };
}
