# ElevenLabs TTS Provider Implementation Guide

## Prerequisites
1. ElevenLabs account with an API key.
2. (Optional) Custom endpoint if using a self‑hosted proxy.

## Steps
1. **Set the endpoint** (defaults to `ELEVENLABS_ENDPOINT` environment variable). If you have a custom URL, pass it via `--dart-define=ELEVENLABS_ENDPOINT=https://your‑endpoint`.
2. **Provide the API key** using a Dart define:
   ```bash
   flutter run \
     --dart-define=ELEVENLABS_API_KEY=YOUR_API_KEY
   ```
   The provider reads the key with `String.fromEnvironment('ELEVENLABS_API_KEY')`.
3. The `ElevenLabsProvider` is automatically instantiated by `TtsProviderRegistry` and will appear in the dropdown.

## Verification
- Select **ElevenLabs** from the provider list, choose a voice, and press **Speak**.
- Audio should be synthesized by ElevenLabs.
