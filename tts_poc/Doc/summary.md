# Project Summary & Setup Guide

This is a **Proof of Concept (POC) Flutter application** designed to demonstrate a unified architecture for integrating multiple Text-to-Speech (TTS) engines.

Its goal is to provide a single, consistent interface (`TtsProvider`) to switch between:

*   **Cloud Providers:** Google Cloud, AWS Polly, Azure Speech.
*   **Premium/SaaS Providers:** ElevenLabs, PlayHT, Murf, etc.
*   **On-Device/Offline Engines:** Sherpa ONNX, Embedded Piper.
*   **Open Source Servers:** Coqui, MaryTTS, Espeak (via HTTP proxy).

## Project Structure

*   **`lib/main.dart`**: The entry point. It initializes the `TtsProviderRegistry`, loads providers, and displays a simple UI to select a provider/voice and speak text.
*   **`lib/tts/providers/`**: Contains the implementations for each service.
    *   **`cloud_providers.dart`**: Google, AWS, Azure (implemented via HTTP/REST).
    *   **`open_source_providers.dart`**: Coqui, MaryTTS, and **Embedded Piper** (which uses Method Channels).
    *   **`device_providers.dart`**: Likely contains `SherpaTtsProvider` (also uses Method Channels).
*   **`native_impl_plan.md`**: **Crucial file.** It contains the manual steps required to set up the native libraries (`.so` files, `.framework`s) and models (`.onnx`) for the offline engines (Sherpa/Piper).

## How to Make it Work

To get this running, you need to configure the specific providers you want to test. You do **not** need to configure all of them at once.

### 1. Install Dependencies
Run this in the `tts_poc` directory:
```bash
flutter pub get
```

### 2. Configure Cloud/Premium Providers (Optional)
These require API keys. You can pass them at build time using `--dart-define`.

*   **Google Cloud:** Requires a `assets/credentials.json` file (Service Account JSON).
*   **AWS Polly:** Requires `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`.
*   **Azure:** Requires `AZURE_SPEECH_KEY`, `AZURE_SPEECH_REGION`.
*   **Others:** See `README.md` for specific keys (e.g., `ELEVENLABS_ENDPOINT`).

### 3. Configure Native/Offline Providers (Complex)
**Sherpa ONNX** and **Embedded Piper** are **not** plug-and-play. They require manual native setup because the models and binary libraries are too large/platform-specific to include by default.

**You must follow `native_impl_plan.md` to:**
1.  **Download Binaries:** Get `.so` files (Android) or `.xcframework` (iOS) for Sherpa/Piper.
2.  **Download Models:** Get `.onnx` voice models (e.g., `pt_BR-male-1.onnx`).
3.  **Place Files:**
    *   **Android:** Put `.so` files in `android/app/src/main/jniLibs/` and models in `android/app/src/main/assets/`.
    *   **iOS:** Embed frameworks and models in the Xcode project.
4.  **Implement Native Code:** The Dart side calls `MethodChannel('sherpa_tts')` or `MethodChannel('embedded_piper')`. You need to ensure the Android/iOS native code actually implements these channels to receive the text and return audio bytes. **Currently, the Dart side expects these channels to exist, but I haven't verified if the native Kotlin/Swift code is fully implemented.**

### 4. Run the App
Example command to run with AWS credentials:
```bash
flutter run --dart-define=AWS_ACCESS_KEY_ID=your_key --dart-define=AWS_SECRET_ACCESS_KEY=your_secret --dart-define=AWS_REGION=us-east-1
```

## Recommended Next Steps
1.  **Decide which provider you want to test first.** (e.g., "I want to see AWS Polly work" or "I want to implement the offline Sherpa TTS").
2.  **If Cloud:** I can help you format the `flutter run` command or set up the `credentials.json`.
3.  **If Native (Sherpa/Piper):** We should check the `android/` and `ios/` directories to see if the native Method Channel implementation code exists or if we need to write it from scratch.

What would you like to focus on first?
