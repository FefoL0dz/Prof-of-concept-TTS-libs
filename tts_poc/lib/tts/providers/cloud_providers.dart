import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/texttospeech/v1.dart' as tts;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../models.dart';
import '../tts_provider.dart';

/// Concrete provider for Google Cloud Text-to-Speech.
class GoogleCloudTtsProvider extends TtsProvider {
  GoogleCloudTtsProvider() : super(id: 'google', displayName: 'Google Cloud TTS');

  tts.TexttospeechApi? _api;
  List<TtsVoice> _voices = const [];
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    final credentialsJson = await rootBundle.loadString('assets/credentials.json');
    final credentials = ServiceAccountCredentials.fromJson(json.decode(credentialsJson));
    final client = await clientViaServiceAccount(
      credentials,
      [tts.TexttospeechApi.cloudPlatformScope],
    );
    _api = tts.TexttospeechApi(client);
    final voiceResponse = await _api!.voices.list();
    _voices = (voiceResponse.voices ?? [])
        .map(
          (voice) => TtsVoice(
            providerId: id,
            voiceId: voice.name ?? 'unknown',
            name: voice.name ?? 'Unknown',
            languageCode: voice.languageCodes?.first ?? 'und',
            gender: voice.ssmlGender,
            isNeural: (voice.naturalSampleRateHertz ?? 0) >= 16000,
            supportedStyles: const [],
          ),
        )
        .where(
          (voice) => const ['pt-BR', 'es', 'en', 'it', 'fr']
              .any((lang) => voice.languageCode.startsWith(lang)),
        )
        .toList(growable: false);
    _initialized = true;
  }

  @override
  bool get isAvailable => _initialized && _api != null;

  @override
  Future<List<TtsVoice>> listVoices() async => _voices;

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) async {
    if (_api == null) {
      throw StateError('Google Cloud API not initialized');
    }
    final synthRequest = tts.SynthesizeSpeechRequest(
      input: tts.SynthesisInput(text: request.text),
      voice: tts.VoiceSelectionParams(
        languageCode: request.voice.languageCode,
        name: request.voice.voiceId,
      ),
      audioConfig: tts.AudioConfig(audioEncoding: 'MP3'),
    );
    final response = await _api!.text.synthesize(synthRequest);
    final audioContent = response.audioContent;
    if (audioContent == null) {
      throw StateError('No audio returned from Google Cloud TTS');
    }
    return base64Decode(audioContent);
  }
}

class AwsPollyProvider extends TtsProvider {
  AwsPollyProvider({
    String? region,
    String? accessKeyId,
    String? secretAccessKey,
    this.sessionToken,
  })  : region = region ?? const String.fromEnvironment('AWS_REGION'),
        accessKeyId = accessKeyId ?? const String.fromEnvironment('AWS_ACCESS_KEY_ID'),
        secretAccessKey = secretAccessKey ?? const String.fromEnvironment('AWS_SECRET_ACCESS_KEY'),
        super(id: 'aws_polly', displayName: 'Amazon Polly');

  final String region;
  final String accessKeyId;
  final String secretAccessKey;
  final String? sessionToken;

  bool get _configured =>
      region.isNotEmpty && accessKeyId.isNotEmpty && secretAccessKey.isNotEmpty;

  bool _initialized = false;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  bool get isAvailable => _initialized && _configured;

  @override
  Future<List<TtsVoice>> listVoices() async {
    if (!_configured) return const [];
    return const [
      TtsVoice(
        providerId: 'aws_polly',
        voiceId: 'Camila',
        name: 'Camila (pt-BR)',
        languageCode: 'pt-BR',
        gender: 'FEMALE',
        isNeural: true,
      ),
      TtsVoice(
        providerId: 'aws_polly',
        voiceId: 'Ricardo',
        name: 'Ricardo (pt-BR)',
        languageCode: 'pt-BR',
        gender: 'MALE',
        isNeural: true,
      ),
      TtsVoice(
        providerId: 'aws_polly',
        voiceId: 'Vitoria',
        name: 'Vitória (pt-BR)',
        languageCode: 'pt-BR',
        gender: 'FEMALE',
        isNeural: true,
      ),
    ];
  }

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) async {
    if (!_configured) {
      throw StateError('AWS Polly is not configured.');
    }
    final host = 'polly.$region.amazonaws.com';
    final uri = Uri.https(host, '/v1/speech');
    final payload = jsonEncode({
      'Text': request.text,
      'LanguageCode': request.voice.languageCode,
      'VoiceId': request.voice.voiceId,
      'OutputFormat': 'mp3',
    });
    final headers = <String, String>{
      'Content-Type': 'application/x-amz-json-1.1',
      'X-Amz-Target': 'com.amazonaws.polly.v1.Polly.SynthesizeSpeech',
    };
    final signer = _AwsSigV4Signer(
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      sessionToken: sessionToken,
      region: region,
      service: 'polly',
    );
    final signedHeaders = signer.sign(
      method: 'POST',
      uri: uri,
      payload: payload,
      headers: headers,
    );
    final response = await http.post(uri, headers: signedHeaders, body: payload);
    if (response.statusCode >= 400) {
      throw StateError('AWS Polly error (${response.statusCode}): ${response.body}');
    }
    return response.bodyBytes;
  }
}

class AzureSpeechProvider extends TtsProvider {
  AzureSpeechProvider({String? region, String? subscriptionKey})
      : region = region ?? const String.fromEnvironment('AZURE_SPEECH_REGION'),
        subscriptionKey =
            subscriptionKey ?? const String.fromEnvironment('AZURE_SPEECH_KEY'),
        super(id: 'azure_speech', displayName: 'Azure Speech Service');

  final String region;
  final String subscriptionKey;

  bool get _configured => region.isNotEmpty && subscriptionKey.isNotEmpty;
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    _initialized = true;
  }

  @override
  bool get isAvailable => _initialized && _configured;

  @override
  Future<List<TtsVoice>> listVoices() async {
    if (!_configured) return const [];
    return const [
      TtsVoice(
        providerId: 'azure_speech',
        voiceId: 'pt-BR-FranciscaNeural',
        name: 'Francisca (pt-BR)',
        languageCode: 'pt-BR',
        gender: 'FEMALE',
        isNeural: true,
        supportedStyles: [
          TtsStyle(id: 'cheerful', displayName: 'Cheerful'),
          TtsStyle(id: 'sad', displayName: 'Sad'),
        ],
      ),
    ];
  }

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) async {
    if (!_configured) {
      throw StateError('Azure Speech is not configured.');
    }
    final uri =
        Uri.https('$region.tts.speech.microsoft.com', '/cognitiveservices/v1');
    final ssml = StringBuffer()
      ..writeln('<speak version="1.0" xml:lang="${request.voice.languageCode}">')
      ..writeln('  <voice name="${request.voice.voiceId}">')
      ..writeln(request.text)
      ..writeln('  </voice>')
      ..writeln('</speak>');
    final response = await http.post(
      uri,
      headers: {
        'Ocp-Apim-Subscription-Key': subscriptionKey,
        'Content-Type': 'application/ssml+xml',
        'X-Microsoft-OutputFormat': 'audio-16khz-64kbitrate-mono-mp3',
        'User-Agent': 'tts-poc',
      },
      body: ssml.toString(),
    );
    if (response.statusCode >= 400) {
      throw StateError('Azure Speech error (${response.statusCode}): ${response.body}');
    }
    return response.bodyBytes;
  }
}

class _AwsSigV4Signer {
  _AwsSigV4Signer({
    required this.accessKeyId,
    required this.secretAccessKey,
    required this.region,
    required this.service,
    this.sessionToken,
  });

  final String accessKeyId;
  final String secretAccessKey;
  final String region;
  final String service;
  final String? sessionToken;

  Map<String, String> sign({
    required String method,
    required Uri uri,
    required String payload,
    Map<String, String>? headers,
  }) {
    final now = DateTime.now().toUtc();
    final date = _formatDate(now);
    final amzDate = _formatAmz(now);
    final payloadHash = sha256.convert(utf8.encode(payload)).toString();
    final canonicalHeaders = StringBuffer();
    final sortedHeaders = <String, String>{};
    for (final entry in headers?.entries ?? const Iterable.empty()) {
      sortedHeaders[entry.key.toLowerCase()] = entry.value.trim();
    }
    sortedHeaders['host'] = uri.host;
    sortedHeaders['x-amz-date'] = amzDate;
    if (sessionToken != null && sessionToken!.isNotEmpty) {
      sortedHeaders['x-amz-security-token'] = sessionToken!;
    }
    final headerKeys = sortedHeaders.keys.toList()..sort();
    for (final key in headerKeys) {
      canonicalHeaders.writeln('$key:${sortedHeaders[key]}');
    }
    final signedHeaders = headerKeys.join(';');
    final canonicalRequest = [
      method,
      uri.path.isEmpty ? '/' : uri.path,
      uri.query,
      canonicalHeaders.toString(),
      signedHeaders,
      payloadHash,
    ].join('\n');
    final credentialScope = '$date/$region/$service/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');
    final signingKey = _deriveKey(date);
    final signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();
    final authorization =
        'AWS4-HMAC-SHA256 Credential=$accessKeyId/$credentialScope, SignedHeaders=$signedHeaders, Signature=$signature';
    return {
      ...sortedHeaders,
      'Authorization': authorization,
    };
  }

  List<int> _deriveKey(String date) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$secretAccessKey')).convert(utf8.encode(date)).bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(service)).bytes;
    final kSigning = Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
    return kSigning;
  }

  String _formatDate(DateTime dateTime) =>
      '${dateTime.year.toString().padLeft(4, '0')}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}';

  String _formatAmz(DateTime dateTime) {
    final date = _formatDate(dateTime);
    final time = '${dateTime.hour.toString().padLeft(2, '0')}${dateTime.minute.toString().padLeft(2, '0')}${dateTime.second.toString().padLeft(2, '0')}';
    return '$date${time}Z';
  }
}
