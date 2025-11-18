
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'tts/models.dart';
import 'tts/providers/cloud_providers.dart';
import 'tts/providers/device_providers.dart';
import 'tts/providers/misc_providers.dart';
import 'tts/providers/open_source_providers.dart';
import 'tts/providers/premium_providers.dart';
import 'tts/services.dart';
import 'tts/tts_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTS POC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'TTS POC'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioCacheService _cacheService = AudioCacheService();
  late final TtsProviderRegistry _registry;
  List<TtsProvider> _providers = const [];
  TtsProvider? _selectedProvider;
  List<TtsVoice> _voices = const [];
  TtsVoice? _selectedVoice;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _registry = TtsProviderRegistry([
      GoogleCloudTtsProvider(),
      AwsPollyProvider(),
      AzureSpeechProvider(),
      ResponsiveVoiceProvider(),
      ISpeechProvider(),
      CoquiServerProvider(),
      EmbeddedPiperProvider(),
      MaryTtsProvider(),
      EspeakProvider(),
      FestivalProvider(),
      ElevenLabsProvider(),
      PlayHtProvider(),
      MurfProvider(),
      WellSaidProvider(),
      ResembleProvider(),
      SherpaTtsProvider(),
    ]);
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await _registry.initializeAll();
      final providers = _registry.availableProviders;
      if (providers.isEmpty) {
        throw StateError('No TTS providers are available.');
      }
      final initialProvider = providers.first;
      final voices = await initialProvider.listVoices();
      setState(() {
        _providers = providers;
        _selectedProvider = initialProvider;
        _voices = voices;
        _selectedVoice = voices.isNotEmpty ? voices.first : null;
      });
    } catch (e) {
      _errorMessage = 'Failed to initialize providers: $e';
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _speak() async {
    if (_selectedProvider == null || _selectedVoice == null || _textController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Provider not ready, no voice selected, or text is empty.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final request = TtsSynthesisRequest(
        text: _textController.text,
        voice: _selectedVoice!,
      );
      final cached = _cacheService.get(request);
      final Uint8List audioBytes;
      if (cached != null) {
        audioBytes = cached;
      } else {
        audioBytes = await _selectedProvider!.synthesize(request);
        _cacheService.save(request, audioBytes);
      }
      await _audioPlayer.setAudioSource(MyCustomSource(audioBytes));
      await _audioPlayer.play();
    } catch (e) {
      _errorMessage = 'Failed to synthesize speech: $e';
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changeProvider(TtsProvider? provider) async {
    if (provider == null) return;
    setState(() {
      _isLoading = true;
      _selectedProvider = provider;
      _voices = const [];
      _selectedVoice = null;
    });
    try {
      final voices = await provider.listVoices();
      setState(() {
        _voices = voices;
        _selectedVoice = voices.isNotEmpty ? voices.first : null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load voices: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to speak',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator(),
            if (!_isLoading && _errorMessage != null)
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            if (!_isLoading && _errorMessage == null) ...[
              if (_providers.isNotEmpty)
                DropdownButton<TtsProvider>(
                  value: _selectedProvider,
                  hint: const Text('Select provider'),
                  onChanged: _changeProvider,
                  items: _providers
                      .map(
                        (provider) => DropdownMenuItem<TtsProvider>(
                          value: provider,
                          child: Text(provider.displayName),
                        ),
                      )
                      .toList(),
                ),
              if (_selectedVoice != null)
                DropdownButton<TtsVoice>(
                  value: _selectedVoice,
                  onChanged: (TtsVoice? newValue) {
                    setState(() {
                      _selectedVoice = newValue;
                    });
                  },
                  items: _voices
                      .map(
                        (voice) => DropdownMenuItem<TtsVoice>(
                          value: voice,
                          child: Text('${voice.name} (${voice.languageCode})'),
                        ),
                      )
                      .toList(),
                ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _speak,
              child: const Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomSource extends StreamAudioSource {
  final Uint8List _buffer;

  MyCustomSource(this._buffer) : super(tag: 'MyCustomSource');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _buffer.length;
    return StreamAudioResponse(
      sourceLength: _buffer.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_buffer.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
