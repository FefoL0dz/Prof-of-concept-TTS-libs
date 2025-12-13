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

| Provider | Category | Free/Paid | Needs API Key? | Endpoint configurable? | Offline? | Native MethodChannel? | Voice list (built‑in) | Human‑like voice score (1-5) | Remarks |
|----------|----------|-----------|----------------|------------------------|----------|-----------------------|-----------------------|------------------------------|---------|
| **Google Cloud TTS** | Online – API key required | Paid | Yes (service‑account JSON) | No (uses [assets/credentials.json](cci:7://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/assets/credentials.json:0:0-0:0)) | No | No | ✅ (full list) | 5 | Requires [assets/credentials.json](cci:7://file:///Users/framework/Desktop/Estudos/Prof-of-concept-TTS-libs/assets/credentials.json:0:0-0:0). |
| **AWS Polly** | Online – API key required | Paid | Yes (AWS_ACCESS_KEY_ID / SECRET) | No (region auto‑detected) | No | No | ✅ (few PT‑BR voices) | 4 | Uses SigV4 signing. |
| **Azure Speech** | Online – API key required | Paid | Yes (AZURE_SPEECH_KEY) | No (region required) | No | No | ✅ (few PT‑BR voices) | 4 | Supports SSML styles. |
| **ElevenLabs** | Online – API key required | Paid | Yes (ELEVENLABS_API_KEY) | Yes (`ELEVENLABS_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | 5 | Premium neural voices. |
| **Play.ht** | Online – API key required | Paid | Yes (PLAYHT_API_KEY) | Yes (`PLAYHT_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | 4 | |
| **Murf.ai** | Online – API key required | Paid | Yes (MURF_API_KEY) | Yes (`MURF_ENDPOINT`) | No | No | ✅ (no preset voices) | 4 | |
| **WellSaid Labs** | Online – API key required | Paid | Yes (WELLSAID_API_KEY) | Yes (`WELLSAID_ENDPOINT`) | No | No | ✅ (no preset voices) | 4 | |
| **Resemble AI** | Online – API key required | Paid | Yes (RESEMBLE_API_KEY) | Yes (`RESEMBLE_ENDPOINT`) | No | No | ✅ (no preset voices) | 4 | |
| **ResponsiveVoice** | Online – API key optional | Paid | Yes (RESPONSIVE_VOICE_KEY) | Yes (`RESPONSIVE_VOICE_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | 3 | |
| **Coqui Server** | Online – No key needed* | Free | No | Yes (`COQUI_ENDPOINT`) | No | No | ✅ (single PT‑BR voice) | 3 | `*` only if your server does not enforce auth. |
| **MaryTTS** | Online – No key needed* | Free | No | Yes (`MARYTTS_ENDPOINT`) | No | No | ❌ (empty list) | 2 | You may need to extend the provider to expose voices. |
| **Espeak NG** | Online – No key needed* | Free | No | Yes (`ESPEAK_ENDPOINT`) | No | No | ❌ (empty list) | 1 | |
| **Festival/Flite** | Online – No key needed* | Free | No | Yes (`FESTIVAL_ENDPOINT`) | No | No | ❌ (empty list) | 1 | |
| **Embedded Piper** | Offline – Native library | Free | No | No | Yes | Yes (`embedded_piper` channel) | ❌ (empty list) | 3 | Requires compiled `.so`/`.framework` and native channel implementation. |
| **Sherpa ONNX** | Offline – Native library | Free | No | No | Yes | Yes (`sherpa_tts` channel) | ✅ (populated by native side) | 3 | Needs `.onnx` models & native binaries. |
| **Device TTS (flutter_tts)** | Device‑built‑in | Free | No | No | Yes (uses OS engine) | No | ✅ (filtered list) | 3 | Works out‑of‑the‑box on Android/iOS. |

\* If your self‑hosted server enforces authentication you’ll need to add a key‑header manually.

---

## Additional considerations

Below is a quick‑reference table with practical factors that often influence the final choice of a TTS provider.

| Provider | Cost (Free/Paid) | Approx. pricing* | Typical latency | Language coverage | Remarks |
|----------|------------------|------------------|----------------|-------------------|---------|
| Google Cloud TTS | Paid | $4‑$16 per million characters (depends on voice) | Low (≈200 ms) | 220+ voices, many languages | High‑quality neural, supports SSML |
| AWS Polly | Paid | $4 per million characters (standard) / $16 (neural) | Low (≈150 ms) | 60+ voices, many languages | Good Portuguese support |
| Azure Speech | Paid | $1‑$4 per million characters | Low (≈180 ms) | 75+ voices, many languages | Strong SSML, custom voice support |
| ElevenLabs | Paid | $5‑$20 per month (subscription) | Medium (≈500 ms) | English (plus a few others) | Very natural neural voices |
| Play.ht | Paid | $15‑$30 per month (tiered) | Medium (≈400 ms) | English, Spanish, etc. | API‑first, easy integration |
| Murf.ai | Paid | $19‑$49 per month | Medium (≈450 ms) | English, Portuguese, etc. | Studio‑grade voices |
| WellSaid Labs | Paid | $30‑$99 per month | Medium (≈400 ms) | English, Spanish, etc. | Premium voice quality |
| Resemble AI | Paid | $25‑$100 per month | Medium (≈450 ms) | English, others | Custom voice cloning |
| ResponsiveVoice | Free (with key) / Paid for premium | Free tier limited, paid plans start $9/mo | High (≈800 ms) | Many languages, but robotic quality |
| Coqui Server | Free (self‑hosted) | No direct cost, server hosting fees | Variable (depends on server) | Many languages, open‑source models | Requires own server |
| MaryTTS | Free (self‑hosted) | No direct cost, server hosting fees | Variable | Many languages, open‑source | Requires setup, limited voice quality |
| Espeak NG | Free | No cost | Low (≈50 ms) | 100+ languages | Very robotic, low quality |
| Festival/Flite | Free | No cost | Low (≈70 ms) | Many languages | Older open‑source engines |
| Embedded Piper | Free (offline) | No cost | Low (≈100 ms) | Many languages, on‑device | Requires model files, good quality |
| Sherpa ONNX | Free (offline) | No cost | Low (≈120 ms) | Limited (few languages) | Requires ONNX models, good quality |
| Device TTS (flutter_tts) | Free | No cost | Low (OS dependent) | Depends on OS voices | Uses system TTS, limited customization |

*Pricing is indicative and may vary by region and usage tier. Always check the provider’s official pricing page.

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
