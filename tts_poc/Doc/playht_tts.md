# Play.ht TTS Provider Implementation Guide

## Prerequisites
1. Play.ht account with an API key.
2. (Optional) Custom endpoint if using a self‑hosted proxy.

## Steps
1. **Set the endpoint** (defaults to `PLAYHT_ENDPOINT` environment variable). If you have a custom URL, pass it via:
   ```bash
   flutter run \
     --dart-define=PLAYHT_ENDPOINT=https://your‑endpoint
   ```
2. **Provide the API key** using a Dart define:
   ```bash
   flutter run \
     --dart-define=PLAYHT_API_KEY=YOUR_API_KEY
   ```
   The provider reads the key with `String.fromEnvironment('PLAYHT_API_KEY')`.
3. The `PlayHtProvider` is automatically instantiated by `TtsProviderRegistry` and will appear in the dropdown.

## Verification
- Select **Play.ht** from the provider list, choose a voice, and press **Speak**.
- Audio should be synthesized by Play.ht.
