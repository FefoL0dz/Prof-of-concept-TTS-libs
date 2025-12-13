# ResponsiveVoice TTS Provider Implementation Guide

## Prerequisites
1. An account with **ResponsiveVoice** (or a self‑hosted proxy) that provides an HTTP API.
2. API key (if required) and endpoint URL.

## Steps
1. **Set the endpoint** via a Dart define or environment variable:
   ```bash
   flutter run \
     --dart-define=RESPONSIVE_VOICE_ENDPOINT=https://api.responsivevoice.org
   ```
2. **Provide the API key** (if your endpoint requires authentication):
   ```bash
   flutter run \
     --dart-define=RESPONSIVE_VOICE_KEY=YOUR_API_KEY
   ```
   The provider reads the key with `String.fromEnvironment('RESPONSIVE_VOICE_KEY')`.
3. The `ResponsiveVoiceProvider` is automatically instantiated by `TtsProviderRegistry` and will appear in the provider dropdown.
4. The provider defines a single voice (`Brazilian Portuguese Female`). Selecting it and pressing **Speak** will send a POST request to the configured endpoint with the text, voiceId and languageCode.

## Verification
- Run the app with the above defines.
- Choose **ResponsiveVoice** from the provider list.
- Press **Speak** and confirm you receive audio from the service.
