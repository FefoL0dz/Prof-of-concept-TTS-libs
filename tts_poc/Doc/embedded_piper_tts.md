# Embedded Piper TTS Provider Implementation Guide

## Prerequisites
1. Build or obtain an **Embedded Piper** native library for the target platform (Android `.so` files, iOS `.framework`).
2. Ensure the native code implements a MethodChannel named `embedded_piper` with a `synthesize` method that returns raw audio bytes (`Uint8List`).
3. Place the compiled binaries in the appropriate platform directories (`android/app/src/main/jniLibs/` for Android, add the framework to the Xcode project for iOS).

## Steps
1. **Add the MethodChannel** (already defined in `EmbeddedPiperProvider`). No extra Dart code is required.
2. **Initialize the provider** – the provider’s `initialize()` simply sets `_initialized = true`. Ensure the native side is ready before the Flutter app starts.
3. **Run the app** – the provider will appear as **Embedded Piper** in the dropdown.
4. **Select a voice** – currently the provider returns an empty voice list (`listVoices()` returns `[]`). You may extend the native side to expose available voices.
5. **Synthesize** – when you press **Speak**, the provider calls the native `synthesize` method via the MethodChannel and plays the returned audio.

## Verification
- Launch the app on a device where the native library is installed.
- Choose **Embedded Piper** from the provider list.
- Press **Speak** with some text.
- You should hear the synthesized speech from the embedded Piper engine.
