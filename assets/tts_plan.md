# Free TTS Strategy (Flutter)

▌ Elaborate a document with  I’m gathering requirements and planning to guide the user toward a free text-to-speech solution for multiple languages in Flutter. I’ll consider
▌ three main paths—on-device,
▌   free-tier cloud, and open-source—and propose actionable next steps referencing specific lines in documentation and Flutter project files to help proceed effectively.
▌
▌ • Explored
▌   └ Read human-like text-to-speech solutions for flutter apps.txt, main.dart
▌
▌ > Goal Recap
▌
▌   - The brief asks for the most natural narration possible (pt-BR first, then ES/EN/IT/FR) while preferring zero-cost options that go beyond the default FlutterTTS voices
▌ that
▌   sound robotic (human-like text-to-speech solutions for flutter apps.txt:2).
▌   - The doc recommends squeezing as much quality as possible from on-device voices (Siri enhanced voices, Google system voices, SherpaTTS) before falling back to cloud APIs
▌   (human-like text-to-speech solutions for flutter apps.txt:3-8).
▌   - When device voices are insufficient, it highlights the generous free tiers from Google Cloud, Amazon Polly, and Azure Speech, plus the cloud_text_to_speech Flutter plugin
▌   to swap among them easily (human-like text-to-speech solutions for flutter apps.txt:11-16).
▌   - For offline or unlimited usage you can self-host neural engines such as Coqui/Piper or bundle SherpaTTS, with the trade-off of extra integration work (human-like text-to-
▌   speech solutions for flutter apps.txt:7, human-like text-to-speech solutions for flutter apps.txt:35-38).
▌   - Premium services like ElevenLabs are optional stretch goals when you need the absolute best narration quality (human-like text-to-speech solutions for
▌ flutter apps.txt:24-
▌   31).
▌
▌   How to proceed
▌
▌   - Device-first baseline: In Flutter, expose flutter_tts as your default engine and surface the enhanced Siri/Google voices that the doc calls out (human-like text-to-speech
▌   solutions for flutter apps.txt:3-7). For iOS you can allow the user to pick the downloaded “Siri Female (pt-BR)” style voices and show instructions for enabling the
▌ enhanced
▌   packs in Settings; on Android prompt the user to install the latest Google TTS and select the WaveNet-capable voice IDs. Keep this path entirely offline/free.
▌   - Sherpa/Piper option on Android: For users willing to install a third-party engine, detect whether SherpaTTS is available and, if so, set FlutterTTS’ engine to
▌   org.woheller69.ttsengine so you can deliver a neural voice without cloud costs (human-like text-to-speech solutions for flutter apps.txt:7).
▌   - Cloud free tier layer: Wrap the Google/AWS/Azure APIs behind a provider abstraction so you can route text to whichever quota still has room. The doc’s numbers (4M chars/
▌   month free for Google standard voices, AWS/Azure 1M-0.5M neural free) let you run real pilots for free if you rotate providers when a quota is exhausted (human-like text-
▌ to-
▌   speech solutions for flutter apps.txt:11-16,32). Use the cloud_text_to_speech package to avoid hand-rolling auth for each API and to list available voices per locale out of
▌   the box (human-like text-to-speech solutions for flutter apps.txt:16). Cache synthesized MP3s on device so you only pay for new text.
▌   - Self-host/offline fallbacks: If you truly need unlimited free characters, plan a Coqui/Piper server (Docker container or lightweight Rust binary) and hit it from Flutter
▌   just like a cloud API. That gives you neural quality with no per-character fee, but you must provision CPU/GPU capacity and ship the models (human-like text-to-speech
▌   solutions for flutter apps.txt:35-38).
▌   - Premium flag: Keep ElevenLabs/Play.ht integration on your roadmap for “narration mode” so you can later upsell users who want near-human acting (human-like text-to-speech
▌   solutions for flutter apps.txt:24-31).
▌
▌   Flutter project adjustments
▌
▌   - Your current prototype talks straight to Google’s REST API with a service-account JSON hardcoded as an asset (lib/main.dart:54-139). Before shipping, move credential
▌   handling off the client (e.g., sign requests via a lightweight backend or Cloud Function) so you don’t leak secrets, and add the asset entry in pubspec.yaml only for local
▌   testing if needed.
▌   - Split _ttsApi into a provider interface (DeviceTtsProvider, GoogleProvider, PollyProvider, AzureProvider, LocalCoquiProvider). This makes it trivial to route text based
▌ on
▌   language priority or offline/online status and mirrors the hybrid strategy from the brief.
▌   - When you load voices, filter by your five target languages and show friendly names (male/female, WaveNet/Neural) instead of raw IDs so testers can compare quality quickly
▌   (lib/main.dart:79-190).
▌   - Add UI affordances to pick provider, voice, speaking style (Amazon <amazon:emotion>, Azure styles, SSML support) since the doc stresses that these expressiveness toggles
▌   make narration feel more “real” (human-like text-to-speech solutions for flutter apps.txt:31).
▌   - Implement persistent caching for synthesized audio (e.g., hash(text+voice+provider) → local file, then feed it through StreamAudioSource as you already do in
▌ MyCustomSource
▌   so repeat playback doesn’t burn quota (lib/main.dart:112-199).
▌   - Keep a device-only fallback path so the app still speaks when offline; for Flutter that simply means failing over to flutter_tts with the system voice when the network
▌   provider throws.
▌
▌   Suggested next steps
▌
▌   1. Decide on the provider stack (device → Sherpa/Piper optional → free-tier cloud) and scaffold a provider interface in lib/.
▌   2. Secure credentials: create the Google/AWS/Azure service accounts, wire them in via server-side token exchange, and add .env/secret management.
▌   3. Build a settings page that lets you pick provider, language, and voice, shows quota usage, and toggles caching/offline fallback.
▌   4. If you need Android offline neural quality, add instructions/logic to detect SherpaTTS or bundle a Piper model and benchmark latency on-device.
▌   5. Once all paths work, add lightweight integration tests or golden audio samples per language to confirm each provider returns speech successfully.
▌  and also with All and Every single possibility of choice

> Implementation Plan

  - Objective – Build a free multilingual (pt-BR > ES/EN/IT/FR) TTS experience in Flutter that sounds as natural as possible, combining on-device, free-tier cloud, and open-
  source paths (human-like text-to-speech solutions for flutter apps.txt:2).
  - Reference scope – Requirements gathered from human-like text-to-speech solutions for flutter apps.txt (entire doc, esp. lines cited below) and current prototype logic in
  lib/main.dart:54-199.

  ———

  Path 1 – On-Device / Offline

  - System voices – Leverage enhanced Siri voices and Google system WaveNet voices before anything else; both are free once downloaded and stay offline (human-like text-to-
  speech solutions for flutter apps.txt:3-8).
    Actionables:
      1. In Flutter, expose flutter_tts as the default provider, enumerate await flutterTts.getVoices, and highlight the enhanced Siri entries (e.g., “Siri Female (pt-BR)”)
  with setup tips for users (human-like text-to-speech solutions for flutter apps.txt:5).
      2. On Android, prompt to install/update Google Text-to-Speech and surface its WaveNet voices (pt-BR, es, fr, it) through the same dropdown (human-like text-to-speech
  solutions for flutter apps.txt:6).
      3. Keep this path fully offline; fall back here when network/cloud providers fail (lib/main.dart:112-199).
  - Sherpa/Piper engine – For Android, detect the SherpaTTS package (org.woheller69.ttsengine) and switch FlutterTTS to it when installed to gain neural quality offline (human-
  like text-to-speech solutions for flutter apps.txt:7).
    Actionables:
      1. Add a capability check (via platform channel) that lists installed TTS engines and offers Sherpa when present.
      2. Provide instructions/link to F-Droid so users can install SherpaTTS and download the pt-BR/Piper model.

  ———

  Path 2 – Free-Tier Cloud APIs

  - Provider stack – Use Google Cloud, Amazon Polly, and Azure Speech free quotas (4M, 1M, 500k chars/month respectively) to cover high-quality neural voices in all target
  languages (human-like text-to-speech solutions for flutter apps.txt:11-16,32).
    Actionables:
      1. Refactor _ttsApi into a provider abstraction (lib/main.dart:54-139) with pluggable implementations (Device, Google, Polly, Azure).
      2. Adopt the cloud_text_to_speech Flutter package so you can query voices and swap providers without custom auth per service (human-like text-to-speech solutions for
  flutter apps.txt:16).
  - Security & caching – Remove the JSON service-account asset from the app bundle; instead fetch scoped tokens from a lightweight backend to avoid credential leakage (lib/
  main.dart:54-75). Cache synthesized files locally keyed by text/voice/provider so repeat playback doesn’t consume quota (lib/main.dart:112-139).
    Actionables:
      1. Create a minimal backend (Cloud Run/Functions) that returns signed tokens for each provider.
      2. Implement disk caching (e.g., path_provider + hashed filename) and reuse MyCustomSource to stream from local storage (lib/main.dart:124-199).
      3. Log quota usage per provider to decide when to rotate.
  - Expressiveness – Surface SSML options and speaking styles (Azure cheerful/sad, Polly <amazon:emotion>) because expressive tags help narration feel human (human-like text-
  to-speech solutions for flutter apps.txt:31).
    Actionables:
      1. Expand UI to select speaking style/emotion per provider.
      2. Validate SSML rendering by previewing audio samples for each language.

  ———

  Path 3 – Open-Source / Self-Hosted

  - Coqui / Piper – When unlimited free usage is mandatory, run Coqui TTS or Piper models (pt-BR, ES, EN, IT, FR available) on your own server or even bundled locally; they
  deliver near-neural quality with no per-character fee (human-like text-to-speech solutions for flutter apps.txt:35-38).
    Actionables:
      1. Spin up a Dockerized Coqui server (VITS/FastSpeech2) and expose a simple REST endpoint returning MP3/WAV.
      2. For on-device experiments, embed Piper models (used by SherpaTTS) and invoke them via FFI; measure latency/size trade-offs.
  - MaryTTS / eSpeak fallback – Keep lightweight engines (MaryTTS, eSpeak, Festival) as last-resort offline options; they’re fully free but more robotic (human-like text-to-
  speech solutions for flutter apps.txt:36-38). Only consider if hardware constraints prevent neural models.

  ———

  Cross-Cutting Steps & Choices

  1. Scaffold provider interface – Create lib/providers/tts_provider.dart with implementations for Device/Sherpa, Google, Polly, Azure, Coqui. Route _speak() through the
  selected provider (lib/main.dart:99-140).
  2. Credentials & env – Add .env/secret handling, backend token exchange, and remove direct asset loading of credentials.json except for local testing (lib/main.dart:54-75).
  3. Voice UX – Filter voices to the five target languages, show metadata (gender, neural/WaveNet) to aid comparison (lib/main.dart:79-190).
  4. Settings screen – Build a page to choose provider, voice, style, cache toggle, and display quota counters.
  5. Offline detection – Automatically fall back to device voices when connectivity drops, ensuring basic narration always works.
  6. Testing – Create integration tests or golden audio samples per provider/language to confirm successful synthesis once each path is wired.

  This document covers every major option described in the requirements doc and ties each next step to specific references so you can proceed with confidence.
