# tts_poc

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## TTS Provider Architecture

The proof-of-concept now exposes every text-to-speech path described in
`tts_class_plan.md` via typed provider classes under `lib/tts/`. The
`TtsProviderRegistry` wires multiple providers (device, Sherpa, Google Cloud,
AWS Polly, Azure, premium services, and open-source engines) behind a consistent
interface. The main UI loads providers dynamically, lists their voices, and uses
`GoogleCloudTtsProvider` by default. Additional providers can be enabled by
implementing their `synthesize` method and adding them to the registry.

### Provider configuration

Several providers expect credentials or HTTP proxy endpoints via
`--dart-define` values at build time:

- `AWS_REGION`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`
- `AZURE_SPEECH_REGION`, `AZURE_SPEECH_KEY`
- `RESPONSIVE_VOICE_ENDPOINT`, `RESPONSIVE_VOICE_KEY`
- `ISPEECH_ENDPOINT`, `ISPEECH_API_KEY`
- `COQUI_ENDPOINT`, `MARYTTS_ENDPOINT`, `ESPEAK_ENDPOINT`, `FESTIVAL_ENDPOINT`
- Premium endpoints such as `ELEVENLABS_ENDPOINT`, `PLAYHT_ENDPOINT`,
  `MURF_ENDPOINT`, `WELLSAID_ENDPOINT`, `RESEMBLE_ENDPOINT` with matching API key
  defines

If an endpoint or API key is missing, the corresponding provider remains
unavailable and is not shown in the dropdown. SherpaTTS and Embedded Piper use
method channels (`sherpa_tts`, `embedded_piper`) that must be implemented on the
native side to return raw audio bytes.
