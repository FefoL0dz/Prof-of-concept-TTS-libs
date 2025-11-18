import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models.dart';
import '../tts_provider.dart';

/// Generic HTTP JSON proxy for providers backed by a custom backend or REST API.
abstract class HttpProxyTtsProvider extends TtsProvider {
  HttpProxyTtsProvider({
    required super.id,
    required super.displayName,
    required this.endpoint,
    this.headersBuilder,
    bool offline = false,
  }) : super(offline: offline);

  /// Endpoint that receives a JSON payload and returns raw audio bytes.
  final Uri? endpoint;

  /// Optional header factory (useful for API keys).
  final Map<String, String> Function()? headersBuilder;

  bool get _configured => endpoint != null;

  @override
  bool get isAvailable => _configured;

  @override
  Future<void> initialize() async {}

  Map<String, dynamic> buildBody(TtsSynthesisRequest request);

  @override
  Future<Uint8List> synthesize(TtsSynthesisRequest request) async {
    if (!_configured) {
      throw StateError('$id provider is not configured (missing endpoint).');
    }
    final headers = {
      'Content-Type': 'application/json',
      if (headersBuilder != null) ...headersBuilder!(),
    };
    final response = await http.post(
      endpoint!,
      headers: headers,
      body: jsonEncode(buildBody(request)),
    );
    if (response.statusCode >= 400) {
      throw StateError('HTTP ${response.statusCode} from $id provider: ${response.body}');
    }
    return response.bodyBytes;
  }
}
