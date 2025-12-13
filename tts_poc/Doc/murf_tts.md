# Murf.ai TTS Provider Implementation Guide

## Prerequisites
1. Murf.ai account with an API key.
2. (Optional) Custom endpoint if you are using a self‑hosted proxy.

## Steps
1. **Set the endpoint** (defaults to `MURF_ENDPOINT` environment variable). If you have a custom URL, pass it via:
   ```bash
   flutter run \
     --dart-define=MURF_ENDPOINT=https://your‑murf-endpoint.com
   ```
2. **Provide the API key** using a Dart define:
   ```bash
   flutter run \
     --dart-define=MURF_API_KEY=YOUR_API_KEY
   ```
   The provider reads the key with `String.fromEnvironment('MURF_API_KEY')`.
3. The `MurfProvider` is automatically instantiated by `TtsProviderRegistry` and will appear in the provider dropdown.

## Verification
- Select **Murf.ai** from the provider list, choose a voice, and press **Speak**.
- Audio should be synthesized by Murf.ai.
