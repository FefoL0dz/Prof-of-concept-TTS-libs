# TTS Choice Catalog

Full catalog of selectable paths, providers, and implementation decisions for the multilingual Flutter narrator.

## 1. Experience Goals
- Prioritize pt-BR, then ES/EN/IT/FR for natural narration (human-like text-to-speech solutions for flutter apps.txt:2)
- Favor zero-cost usage tiers, keep offline fallbacks, allow premium opt-in when quality demands it

## 2. Platform Paths
1. **On-device defaults** – Use `flutter_tts` with enhanced Siri voices on iOS and Google WaveNet system voices on Android (`human-like text-to-speech solutions for flutter apps.txt:3-6`).
2. **Android SherpaTTS/Piper** – Switch engine to `org.woheller69.ttsengine` when installed for offline neural quality (`human-like text-to-speech solutions for flutter apps.txt:7`).
3. **Free-tier cloud** – Rotate between Google Cloud TTS, Amazon Polly, Azure Speech per quota (`human-like text-to-speech solutions for flutter apps.txt:11-16`).
4. **Cross-platform APIs** – ResponsiveVoice, iSpeech, Unreal Speech, Voice RSS, etc. for quick integration (`human-like text-to-speech solutions for flutter apps.txt:17-21`).
5. **Premium AI** – ElevenLabs, WellSaid Labs, Murf.ai, Play.ht, Resemble AI for “narration mode” upgrades (`human-like text-to-speech solutions for flutter apps.txt:24-31`).
6. **Open-source/self-hosted** – Coqui/Piper servers, MaryTTS, eSpeak/Festival for unlimited offline usage (`human-like text-to-speech solutions for flutter apps.txt:33-38`).

## 3. Provider Choices
| Category | Provider | Strength | Cost option |
| --- | --- | --- | --- |
| On-device | iOS Siri enhanced voices | Neural-quality offline voices including pt-BR | Free (download voice pack) |
|  | Android Google TTS WaveNet | Improved voices on recent devices | Free once installed |
|  | SherpaTTS (Piper) | Offline neural, multi-language | Free app + model download |
| Cloud | Google Cloud TTS | WaveNet/Neural2 voices, 4M free chars/month | Free tier + pay-as-you-go |
|  | Amazon Polly | Neural voices, 1M free chars/month for 12 months | Free trial -> PAYG |
|  | Azure Speech | 500k neural chars/month on F0 tier | Free tier -> PAYG |
|  | IBM Watson TTS | Pronunciation editor, 10k chars/month Lite | Free lite -> paid |
|  | ResponsiveVoice | Easy JS integration | Free non-commercial / license |
|  | iSpeech | SDK/API, celebrity voices | Free dev tier -> paid |
| Premium | ElevenLabs | Ultra-realistic, cloning | 10k chars free -> plans |
|  | WellSaid Labs | Studio-grade English voices | Subscription |
|  | Murf.ai | Multi-language creator platform | Free minutes -> plans |
|  | Play.ht | Aggregated neural + custom voices | Limited free -> subscription |
|  | Resemble AI | Custom cloning | Paid |
| Open-source | Coqui TTS / Piper | Host yourself, neural | Free, infra costs |
|  | MaryTTS | Java-based multi-language | Free |
|  | eSpeak NG / Festival / Flite | Ultra-lightweight | Free |

## 4. Implementation Decisions
- **Provider abstraction** – Replace `_ttsApi` with modular providers (Device, Sherpa, Google, Polly, Azure, Coqui) for routing logic (`lib/main.dart:54-139`).
- **Voice filtering** – Limit dropdown to pt-BR/ES/EN/IT/FR, show readable labels (gender, WaveNet) (`lib/main.dart:79-190`).
- **Credentials** – Remove embedded JSON asset, fetch tokens via backend (`lib/main.dart:54-75`).
- **Caching** – Persist synthesized audio (hash text+voice+provider) and feed via `MyCustomSource` (`lib/main.dart:112-199`).
- **SSML/styling** – Provide UI toggles for Azure styles, Polly `<amazon:emotion>`, Google prosody tags (`human-like text-to-speech solutions for flutter apps.txt:31`).
- **Fallback logic** – Detect connectivity and engine availability to fall back to on-device paths automatically.

## 5. Decision Tree
1. **Connectivity available?**
   - No → Use on-device Siri/Google voices → SherpaTTS if installed → Piper embedded → MaryTTS/eSpeak last.
   - Yes → Check remaining free-tier quota.
2. **Quota available?**
   - Google quota left → Use Google WaveNet/Neural2 voice per language priority.
   - Else AWS quota left → Use Polly (choose Camila/Vitória/Ricardo/Thiago for pt-BR).
   - Else Azure quota left → Use Francisca, Aria, etc.
   - Else fallback to cached audio or on-device.
3. **User opted for premium narration?**
   - Yes → Offer ElevenLabs/Play.ht voice list and bill accordingly.
4. **Need unlimited offline?**
   - Deploy Coqui/Piper server or embed model locally depending on hardware budget.

## 6. Testing & Validation Choices
- Golden audio samples per language/provider.
- Integration tests hitting each provider’s SDK/REST stub.
- Manual QA scripts to verify SherpaTTS detection and fallback path.

## 7. Next Steps Checklist
1. Scaffold provider interface and settings UI.
2. Build backend token service (.env/secret management).
3. Add voice/style selectors and caching controls.
4. Document SherpaTTS installation for users.
5. Prototype Coqui/Piper server.
6. Add premium provider toggle.
7. Create regression tests for `_speak()` routing.

This catalog enumerates every configurable choice for the app so future planning can pick the best combination per deployment scenario.
