# SherpaTTS Native Integration Plan

Goal: implement platform-channel handlers that power `SherpaTtsProvider` inside `lib/tts/providers/device_providers.dart`. Both Android and iOS must listen on `MethodChannel("sherpa_tts")`, handle the `synthesize` method, call Sherpa/Piper native APIs, and return raw audio bytes to Dart.

## 1. Android Implementation Plan

1. **Dependencies**
   - Add SherpaTTS/Piper runtime library. Options:
     - Use existing SherpaTTS app/engine via Android `TextToSpeech` API (if installed) — but we want direct control, so integrate the Sherpa/Piper native library.
     - Include Piper binaries and models in `android/app/src/main/assets` and call them via JNI.
   - Add Kotlin coroutines or background threading to offload synthesis off the main thread.

2. **Channel Setup**
   - Open `android/app/src/main/kotlin/.../MainActivity.kt` (or `MainActivity.java` if using Java).
   - Inside `configureFlutterEngine`, create a `MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "sherpa_tts")` and set a `setMethodCallHandler`.

3. **Handling `synthesize`**
   - Extract arguments: `text` (String), `voiceId` (String), `languageCode` (String).
   - Launch a background coroutine or `AsyncTask` to avoid blocking the UI.
   - Initialize Sherpa/Piper engine lazily: load model files once (maybe map `voiceId` to a model asset path).
   - Run synthesis, producing PCM samples (Float/Int16).
   - Encode PCM to MP3 or return raw PCM as bytes (the Dart `just_audio` pipeline expects MP3 currently; consider encoding to WAV/MP3 via `Lame4Android` or change Dart side to handle WAV).
   - Return the byte array via `result.success(byteArray)`; handle errors by calling `result.error` with message/stack.

4. **Model Management**
   - Store model files under `android/app/src/main/assets/sherpa/<voiceId>` or download on first run.
   - Provide a mapping in Kotlin from Dart `voiceId` to actual file names.

5. **Permissions & Performance**
   - No runtime permissions needed if all processing is local.
   - Ensure native code runs off main thread and handles multiple calls sequentially.

6. **Testing**
   - Add instrumentation or unit tests for the Kotlin `synthesize` handler.
   - From Flutter, select Sherpa provider and verify audio bytes return.

## 2. iOS Implementation Plan

1. **Dependencies**
   - Integrate Sherpa/Piper library for iOS (C++/ObjC bridging). If official iOS build isn’t available, bundle Piper models and use a C bridging header.
   - Alternatively, rely on existing `AVSpeechSynthesizer` (but that’s redundant with Device provider). For true Sherpa integration, include the Piper runtime.

2. **Channel Setup**
   - Open `ios/Runner/AppDelegate.swift` (or `AppDelegate.m` if Objective-C).
   - In `application(_:didFinishLaunchingWithOptions:)`, create `FlutterMethodChannel(name: "sherpa_tts", binaryMessenger: controller.binaryMessenger)` and set handler.

3. **Handling `synthesize`**
   - Extract arguments as on Android.
   - Dispatch onto background queue to run Sherpa/Piper inference (using GCD).
   - Initialize Piper runtime (load model from bundle) and synthesize audio to PCM.
   - Encode to MP3 or WAV (e.g., use AVAudioConverter to produce MP3, or return PCM + update Dart to stream WAV).
   - Send `FlutterStandardTypedData(bytes: data)` back via `result(data)`.

4. **Model Management**
   - Include `.onnx` or `.bin` Piper model files in `ios/Runner/Resources` and update `Runner.xcodeproj` to bundle them.
   - Map `voiceId` to model path (similar strategy as Android).

5. **Performance & Memory**
   - Ensure synchronous channel calls don’t block UI; run inference on background thread.
   - Manage memory for large models carefully.

6. **Testing**
   - Build/run on iOS simulator/device; select Sherpa provider and confirm audio playback.

## 3. Cross-Cutting Considerations

- **Audio format**: Today Dart expects MP3 via `MyCustomSource`. Decide whether native code outputs MP3 (requires encoder) or change Dart player to accept WAV/PCM. For simplicity, consider returning WAV (PCM + header) and set `contentType` accordingly (`audio/wav`).
- **Error handling**: Native code should report descriptive errors back to Flutter; `_changeProvider` and `_speak` already show `_errorMessage`.
- **Fallback**: If Sherpa channel fails, the provider should reflect `isAvailable = false` so UI hides it.
- **Documentation**: Update README to include steps for building native Sherpa support (install models, etc.).

## 4. Step-by-Step Execution Order

1. Acquire/build Sherpa/Piper native libs for Android/iOS.
2. Copy model files into respective platform assets/resources.
3. Implement Android `MethodChannel` handler and synthesis pipeline.
4. Implement iOS `MethodChannel` handler and synthesis pipeline.
5. Adjust Dart `SherpaTtsProvider` if audio format changes (e.g., expecting WAV vs MP3).
6. Test on Android emulator/device; capture logs.
7. Test on iOS simulator/device.
8. Update documentation and commit.

This plan provides a detailed blueprint to implement the Sherpa native channels cleanly on both platforms before touching any platform code.



I can’t actually wire up the sherpa_tts channel without the native runtime—we need Piper/Sherpa binaries (and at least one model file) checked into the repo or referenced via
a pod/Gradle dependency. Once those libraries are in place I can add the Kotlin/Swift handlers, but with nothing to call on either platform we’d just return errors. Let me
know when you’ve added the native Sherpa/Piper build artifacts (or picked a specific SDK) and I’ll wire up the channel exactly as in the plan.

▌ Yeah, ok but explain me where should I go and what should I change

> Here’s what you need in place before I can hook up the channel. Think of it in two halves (Android/iOS). Once these pieces exist, wiring the Kotlin/Swift handlers is
straightforward.

———

1. Gather native artifacts

- Download/build the Sherpa/Piper runtime for each platform. Typically you need:
   - Core library (JNI .so for Android, .a/.framework for iOS)
   - Model files (e.g. pt-br-voice-x.onnx plus config JSON)
   - Any extra resources (phoneme dicts, etc.)
- Keep at least one model per language you want to expose; you can map them via voiceId → file name.

———

2. Drop them in the project

- Android: place .so files under android/app/src/main/jniLibs/<abi>/ (e.g., jniLibs/arm64-v8a/libpiper.so). Put model files in android/app/src/main/assets/sherpa/ or
  somewhere accessible (remember to load them via assets.open).
- iOS: add the static library or framework to ios/Runner. Using Xcode:
   - Drag the .xcframework/.a + headers into the Runner target.
   - Add the model files to the app bundle (right-click “Runner” → “Add files…” → check “Copy items if needed”).

———

3. Set up Kotlin/Swift code

- Android:
   1. Edit android/app/src/main/kotlin/<package>/MainActivity.kt.
   2. In configureFlutterEngine, register:

      MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "sherpa_tts")
      .setMethodCallHandler { call, result -> … }
   3. Inside the handler, parse text, voiceId, languageCode.
   4. Offload to CoroutineScope(Dispatchers.Default) (or similar):
      - Initialize the Piper engine (load model file matching voiceId).
      - Run inference → PCM samples.
      - Encode to WAV/MP3. (If you don’t have an encoder, return WAV: add a simple header + PCM 16-bit audio.)
      - Return result.success(byteArray).
- iOS:
   1. Open ios/Runner/AppDelegate.swift.
   2. After GeneratedPluginRegistrant.register(with:), add:

      let channel = FlutterMethodChannel(name: "sherpa_tts", binaryMessenger: controller.binaryMessenger)
      channel.setMethodCallHandler { call, result in … }
   3. Dispatch synthesize work onto a background queue. Load the model from the bundle, run the Piper API, build WAV/MP3 bytes, and call result(data).

———

4. Update Dart if audio format changes

- If native layers return WAV (recommended to avoid MP3 encoder complexity), update MyCustomSource’s contentType to audio/wav. just_audio can play WAV as well.

———

5. Document + test

- Add README notes on how to build the native libraries and where to place models.
- Rebuild both apps, select “SherpaTTS” in the Flutter UI, and ensure audio plays.

———

Once you’ve added the native libraries and model files to the repo (or specified the packages you’re using), I can implement the Kotlin/Swift handlers for you. Without actual
native functions to call, the Flutter side will keep hitting MissingPluginException. So the next concrete step is: drop in the Piper/Sherpa SDK files, confirm the model
paths, and we’ll wire everything together.
