# TTS Provider Quick‑Reference Guide

This document categorises every [TtsProvider](cci:2://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/tts_poc/lib/tts/providers/open_source_providers.dart:78:0-98:1) shipped with the **tts_poc** demo and summarises the key differences that help you decide which one to use.

---

## 1. High‑level classification

| Category | Description |
|----------|-------------|
| **Online – API key required** | Calls a cloud service over HTTPS. You must supply an API key (via `--dart-define` or environment variable). |
| **Online – No key needed** | Calls a public HTTP endpoint that does not require authentication. |
| **Offline – Native library** | Runs completely on‑device using a native binary (`.so` / `.xcframework`) accessed through a `MethodChannel`. No network traffic. |
| **Device‑built‑in** | Uses the OS‑provided TTS engine (`flutter_tts`). No extra keys or binaries. |

---

## 2. Provider table

| Provider | Category | Needs API Key? | Endpoint configurable? | Offline? | Native MethodChannel? | Voice list (built‑in) | Remarks |
|----------|----------|----------------|------------------------|----------|-----------------------|-----------------------|---------|
| **Google Cloud TTS** | Online – API key required | Yes (service‑account JSON) | No (uses [assets/credentials.json](cci:7://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/assets/credentials.json:0:0-0:0)) | No | No | ✅ (full list) | Requires [assets/credentials.json](cci:7://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/assets/credentials.json:0:0-0:0). |
| **AWS Polly** | Online – API key required | Yes (AWS_ACCESS_KEY_ID / SECRET) | No (region auto‑detected) | No | No | ✅ (few PT‑BR voices) | Uses SigV4 signing. |
| **Azure Speech** | Online – API key required | Yes (AZURE_SPEECH_KEY) | No (region required) | No | No | ✅ (few PT‑BR voices) | Supports SSML styles. |
| **ElevenLabs** | Online – API key required | Yes (ELEVENLABS_API_KEY) | Yes (`ELEVENLABS_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | Premium neural voices. |
| **Play.ht** | Online – API key required | Yes (PLAYHT_API_KEY) | Yes (`PLAYHT_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | |
| **Murf.ai** | Online – API key required | Yes (MURF_API_KEY) | Yes (`MURF_ENDPOINT`) | No | No | ✅ (no preset voices) | |
| **WellSaid Labs** | Online – API key required | Yes (WELLSAID_API_KEY) | Yes (`WELLSAID_ENDPOINT`) | No | No | ✅ (no preset voices) | |
| **Resemble AI** | Online – API key required | Yes (RESEMBLE_API_KEY) | Yes (`RESEMBLE_ENDPOINT`) | No | No | ✅ (no preset voices) | |
| **ResponsiveVoice** | Online – API key optional | Yes (RESPONSIVE_VOICE_KEY) | Yes (`RESPONSIVE_VOICE_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | |
| **Coqui Server** | Online – No key needed* | No | Yes (`COQUI_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | `*` only if your server does not enforce auth. |
| **MaryTTS** | Online – No key needed* | No | Yes (`MARYTTS_ENDPOINT`) | No | No | ❌ (empty list) | You may need to extend the provider to expose voices. |
| **Espeak NG** | Online – No key needed* | No | Yes (`ESPEAK_ENDPOINT`) | No | No | ❌ (empty list) | |
| **Festival/Flite** | Online – No key needed* | No | Yes (`FESTIVAL_ENDPOINT`) | No | No | ❌ (empty list) | |
| **Embedded Piper** | Offline – Native library | No | No | Yes | Yes (`embedded_piper` channel) | ❌ (empty list) | Requires compiled `.so`/`.framework` and native channel implementation. |
| **Sherpa ONNX** | Offline – Native library | No | No | Yes | Yes (`sherpa_tts` channel) | ✅ (populated by native side) | Needs `.onnx` models & native binaries. |
| **Device TTS (flutter_tts)** | Device‑built‑in | No | No | Yes (uses OS engine) | No | ✅ (filtered list) | Works out‑of‑the‑box on Android/iOS. |

\* If your self‑hosted server enforces authentication you’ll need to add a key‑header manually.

---

## 3. How to pick the right provider

| Decision point | Recommended providers |
|----------------|----------------------|
| **No network / fully offline** | `Device TTS`, `Sherpa ONNX`, `Embedded Piper` |
| **Prefer free/open‑source server** | `Coqui Server`, `MaryTTS`, `Espeak NG`, [Festival](cci:2://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/tts_poc/lib/tts/providers/open_source_providers.dart:123:0-144:1) |
| **Need high‑quality neural voices** | `Google Cloud`, [ElevenLabs](cci:2://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/tts_poc/lib/tts/providers/premium_providers.dart:4:0-39:1), `WellSaid Labs`, `Murf.ai` |
| **Already have AWS credentials** | `AWS Polly` |
| **Already have Azure subscription** | `Azure Speech` |
| **Want a quick demo without any keys** | `Coqui Server` (if you have a running instance) or `Device TTS` |
| **Want to experiment with many languages** | `Google Cloud` (largest voice catalogue) |
| **Running on low‑end device, no internet** | `Device TTS` (uses system voices) or `Sherpa ONNX` (once models are installed) |

---

### Quick start checklist

1. **Add required keys** – use `flutter run --dart-define=KEY=VALUE` or set env vars.  
2. **Configure endpoints** – for the providers that read `*_ENDPOINT` (Coqui, MaryTTS, etc.).  
3. **Install native binaries** – only for [Sherpa](cci:2://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/tts_poc/lib/tts/providers/device_providers.dart:59:0-114:1) and `Embedded Piper` (see [native_impl_plan.md](cci:7://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/native_impl_plan.md:0:0-0:0)).  
4. **Run the app** – the provider dropdown will only show the ones whose `isAvailable` evaluates to `true`.

Feel free to refer back to the individual provider docs in the `Doc/` folder for the exact setup steps.
