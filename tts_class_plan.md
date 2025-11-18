# TTS Provider Class Plan

Structured plan to implement a dedicated class for every Text-to-Speech option referenced in `human-like text-to-speech solutions for flutter apps.txt` and the current prototype (`lib/main.dart`).

## 1. Architectural Overview

1. Define `abstract class TtsProvider` with methods `Future<void> initialize()`, `Future<List<TtsVoice>> listVoices()`, `Future<Uint8List> synthesize({required String text, required TtsVoice voice, TtsStyle? style})`, and `bool get isOffline`. Shared `TtsVoice` model wraps provider metadata (id, languageCode, label, gender, offline flag).
2. Add `TtsProviderRegistry` that holds ordered providers (device → Sherpa → cloud → self-hosted → premium). `_speak()` in `lib/main.dart:99-140` becomes a registry call that selects provider based on connectivity/quota/user selection.
3. Update UI to pick provider/voice/style per provider (`lib/main.dart:79-190`).

## 2. Provider Classes

### 2.1 Device Providers
- **`DeviceTtsProvider`** – wraps `flutter_tts` to expose enhanced Siri voices (iOS) and Google system voices (Android) (`human-like text-to-speech solutions for flutter apps.txt:3-6`).
  - Dependencies: `flutter_tts`, `platform` detection.
  - Initialization: configure `await flutterTts.awaitSpeakCompletion(true)` and gather voices via `getVoices()`.
  - Synthesis: call `flutterTts.speak` but pipe audio via a recorder callback or instruct UI to hand playback to system.
- **`SherpaTtsProvider`** – uses platform channel to switch Android engine to `org.woheller69.ttsengine` and then reuses `flutter_tts` calls (`human-like text-to-speech solutions for flutter apps.txt:7`).
  - Initialization: check installed engines, prompt user if absent.
  - `isOffline = true`.

### 2.2 Cloud Providers (Free Tier)
- **`GoogleCloudTtsProvider`** – wraps Google Cloud Text-to-Speech REST API (WaveNet/Neural2) (`human-like text-to-speech solutions for flutter apps.txt:11`).
  - Initialization: fetch OAuth token from backend instead of loading `assets/credentials.json` (`lib/main.dart:54-75`).
  - Voices: cache result of `voices.list` filtered to pt-BR/ES/EN/IT/FR.
  - Synthesis: POST `/v1/text:synthesize`, decode base64 audio, return MP3 bytes.
- **`AwsPollyProvider`** – uses AWS Polly SDK/REST for Neural voices (Camila/Vitória/Ricardo/Thiago) (`human-like text-to-speech solutions for flutter apps.txt:12`).
  - Needs Signature V4, best handled server-side.
  - Supports Polly styles `<amazon:emotion>`; accept `TtsStyle` to inject SSML.
- **`AzureSpeechProvider`** – calls Azure Speech `synthesize` endpoint for voices like Francisca, Aria with styles (cheerful, sad) (`human-like text-to-speech solutions for flutter apps.txt:13,31`).
  - Requires token service to exchange subscription key.

### 2.3 Cross-Platform API Providers
- **`ResponsiveVoiceProvider`** – interacts with their JS API via WebView plugin for quick multi-language coverage (`human-like text-to-speech solutions for flutter apps.txt:19`).
- **`ISpeechProvider`** – simple REST/SDK integration offering natural voices and character voices (`human-like text-to-speech solutions for flutter apps.txt:20`).

### 2.4 Premium Providers
- **`ElevenLabsProvider`** – ultra-realistic voices with optional cloning (`human-like text-to-speech solutions for flutter apps.txt:24`).
- **`PlayHtProvider`**, **`MurfProvider`**, **`WellSaidProvider`**, **`ResembleProvider`** – optional classes toggled behind a “premium narration” feature flag (`human-like text-to-speech solutions for flutter apps.txt:25-30`). Each shares the same interface but may require longer synthesis times and user-specific API keys.

### 2.5 Open-Source/Self-Hosted Providers
- **`CoquiServerProvider`** – HTTP client to a self-hosted Coqui/Piper server returning WAV/MP3 (`human-like text-to-speech solutions for flutter apps.txt:35`).
  - Config: base URL, selected model per language.
- **`EmbeddedPiperProvider`** – uses FFI to call Piper binaries/models packaged with the app (Android/Linux) for offline neural quality.
- **`MaryTtsProvider`** – optional Java server client for languages where MaryTTS voices exist (`human-like text-to-speech solutions for flutter apps.txt:36`).
- **`EspeakProvider` / `FestivalProvider`** – fallback providers for ultra-low-resource scenarios; flag as low-quality but fully offline (`human-like text-to-speech solutions for flutter apps.txt:37`).

## 3. Supporting Classes
1. **`TtsVoice`** – attributes: `providerId`, `voiceId`, `languageCode`, `displayName`, `gender`, `capabilities (neural, wavenet, emotion)`, `isOffline`.
2. **`TtsStyle`** – enumeration of supported styles (e.g., `azureCheerful`, `pollyNewscaster`, `default`).
3. **`AudioCacheService`** – responsible for hashing `(provider, voiceId, text, style)` and storing MP3 via `path_provider` to reuse audio (`lib/main.dart:112-199`).
4. **`QuotaTracker`** – persists per-provider usage, informs registry when to skip someone whose free tier is exhausted (`human-like text-to-speech solutions for flutter apps.txt:11-16`).

## 4. Implementation Steps per Provider
For every provider class:
1. **Config Definition** – API keys, endpoint URLs, engine IDs.
2. **Initialization Flow** – Acquire tokens/permissions, ensure dependencies (voice packs, Sherpa app) exist.
3. **Voice Discovery** – Map provider-specific voice schema to `TtsVoice` list filtered to pt-BR/ES/EN/IT/FR (`lib/main.dart:79-190`).
4. **Synthesis Pipeline** – Build request, support SSML/styling, fetch bytes, store via `AudioCacheService`.
5. **Error & Fallback** – Throw provider-specific exceptions; registry catches and tries the next provider path.

## 5. Testing Plan
- Mock each provider’s network layer and assert `synthesize` outputs bytes.
- Integration tests for Device/Sherpa using emulators with different engines installed.
- Golden sample tests comparing cached audio hash to expected values.
- Registry tests ensuring fallback order (device → Sherpa → cloud → open-source → premium) is respected.

## 6. Documentation Deliverables
- Update README to describe each provider class and required setup (API keys, installing Sherpa, deploying Coqui server).
- Provide troubleshooting guides per provider (quota errors, missing voice packs, SSML validation failures).

This plan ensures every TTS option identified in the requirements has a dedicated class with clear responsibilities, dependencies, and integration steps.
