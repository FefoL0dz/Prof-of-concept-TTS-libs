import '../models.dart';
import 'http_proxy_provider.dart';
import 'provider_utils.dart';

class ResponsiveVoiceProvider extends HttpProxyTtsProvider {
  ResponsiveVoiceProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('RESPONSIVE_VOICE_KEY'),
        super(
          id: 'responsive_voice',
          displayName: 'ResponsiveVoice',
          endpoint: endpoint ?? parseEnvUri('RESPONSIVE_VOICE_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('RESPONSIVE_VOICE_KEY');
            return key.isEmpty ? <String, String>{} : {'X-API-Key': key};
          },
        );

  final String _apiKey;

  bool get _hasKey => _apiKey.isNotEmpty;

  @override
  bool get isAvailable => endpoint != null && _hasKey;

  @override
  Future<List<TtsVoice>> listVoices() async => const [
        TtsVoice(
          providerId: 'responsive_voice',
          voiceId: 'Brazilian Portuguese Female',
          name: 'ResponsiveVoice pt-BR',
          languageCode: 'pt-BR',
        ),
      ];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voiceId': request.voice.voiceId,
        'languageCode': request.voice.languageCode,
      };
}

class ISpeechProvider extends HttpProxyTtsProvider {
  ISpeechProvider({Uri? endpoint, String? apiKey})
      : _apiKey = apiKey ?? const String.fromEnvironment('ISPEECH_API_KEY'),
        super(
          id: 'ispeech',
          displayName: 'iSpeech',
          endpoint: endpoint ?? parseEnvUri('ISPEECH_ENDPOINT'),
          headersBuilder: () {
            final key = apiKey ?? const String.fromEnvironment('ISPEECH_API_KEY');
            return key.isEmpty ? <String, String>{} : {'X-API-Key': key};
          },
        );

  final String _apiKey;

  bool get _hasKey => _apiKey.isNotEmpty;

  @override
  bool get isAvailable => endpoint != null && _hasKey;

  @override
  Future<List<TtsVoice>> listVoices() async => const [
        TtsVoice(
          providerId: 'ispeech',
          voiceId: 'brportuguesefemale',
          name: 'iSpeech pt-BR Female',
          languageCode: 'pt-BR',
        ),
      ];

  @override
  Map<String, dynamic> buildBody(TtsSynthesisRequest request) => {
        'text': request.text,
        'voiceId': request.voice.voiceId,
        'languageCode': request.voice.languageCode,
      };
}
