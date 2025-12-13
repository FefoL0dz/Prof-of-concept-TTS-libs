# WellSaid Labs TTS Provider Implementation Guide

## Prerequisites
1. WellSaid Labs account with an API key.
2. (Optional) Custom endpoint if using a self‑hosted proxy.

## Steps
1. **Set the endpoint** (defaults to `WELLSAID_ENDPOINT` environment variable). If you have a custom URL, pass it via:
   ```bash
   flutter run \
     --dart-define=WELLSAID_ENDPOINT=https://your‑wellsaid-endpoint.com
   ```
2. **Provide the API key** using a Dart define:
   ```bash
   flutter run \
     --dart-define=WELLSAID_API_KEY=YOUR_API_KEY
   ```
   The provider reads the key with `String.fromEnvironment('WELLSAID_API_KEY')`.
3. The `WellSaidProvider` is automatically instantiated by `TtsProviderRegistry` and will appear in the provider dropdown.

## Verification
- Select **WellSaid Labs** from the provider list, choose a voice, and press **Speak**.
- Audio should be synthesized by WellSaid Labs.
