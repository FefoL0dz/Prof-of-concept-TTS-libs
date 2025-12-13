# Coqui Server TTS Provider Implementation Guide

## Prerequisites
1. A running Coqui/Piper server exposing a REST endpoint.
2. The endpoint URL (e.g., `https://my-coqui-server.com/api/tts`).

## Steps
1. **Set the endpoint** via a Dart define or environment variable:
   ```bash
   flutter run \
     --dart-define=COQUI_ENDPOINT=https://my-coqui-server.com/api/tts
   ```
   The provider reads `COQUI_ENDPOINT` using `String.fromEnvironment`.
2. No additional API key is required unless your server enforces authentication (in that case modify the provider accordingly).
3. The `CoquiServerProvider` is automatically instantiated by `TtsProviderRegistry` and will appear in the dropdown.

## Verification
- Select **Coqui/Piper Server** from the provider list, choose the provided voice, and press **Speak**.
- Audio should be synthesized by your Coqui server.
