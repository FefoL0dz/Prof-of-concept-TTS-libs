# Device TTS Provider Implementation Guide

## Overview
The `DeviceTtsProvider` uses the platform's built‑in TTS engine (Google TTS on Android, Siri on iOS) via the `flutter_tts` plugin.

## Prerequisites
- No external credentials are required.
- Ensure the device has TTS voices installed (most Android/iOS devices include a few by default).

## Steps
1. **Add the plugin** (already present in `pubspec.yaml`):
   ```yaml
   dependencies:
     flutter_tts: ^4.2.3
   ```
2. **Run `flutter pub get`** to fetch the plugin.
3. The provider is instantiated automatically by `TtsProviderRegistry`.
4. When the app starts, `DeviceTtsProvider.initialize()` loads the available voices and filters them to a short list (pt‑BR, es‑ES, en‑US, it‑IT, fr‑FR).
5. The UI will list these voices; selecting one and pressing **Speak** will call `flutter_tts.speak` internally.

## Verification
- Launch the app on a device.
- Choose **Device Voices** from the provider dropdown.
- Pick a voice and press **Speak**.
- You should hear the system‑generated speech.
