
## Sherpa/Piper Artifact Setup Guide

Follow these steps to obtain the native binaries/models for both platforms before implementing the method channels.

### Android
1. **Download Piper/Sherpa libraries**
   1. Open https://github.com/k2-fsa/sherpa-onnx/releases and download the latest `sherpa-onnx-android-aar.zip`. Inside you’ll find the JNI `.so` files (`libsherpa-onnx-jni.so`) for each ABI.
   2. For Piper voices, visit https://github.com/rhasspy/piper/releases and download a model package that matches your target language. For example, `pt_BR-male-1.onnx.tar.gz` contains:
      - `model.onnx`
      - `config.json`
      - `espeak-ng` phoneme files
      Extract this archive locally so you have the `.onnx` and `config.json` files ready.
   3. Optional: If you prefer pre-made samples, rhasspy hosts example downloads at https://rhasspy.github.io/piper-samples/ (click “Download model” under the voice you want).
2. **Place native libs**
   - Extract the `.so` files (e.g., `libpiper.so`, `libsherpa_onnx_jni.so`) by ABI.
   - Copy to `android/app/src/main/jniLibs/arm64-v8a/` and `jniLibs/armeabi-v7a/` as needed.
3. **Bundle models**
   - Create `android/app/src/main/assets/sherpa/` and drop your model files (`pt-br-voice.onnx`, `config.json`, dictionary files).
   - Record voiceId → file mapping (e.g., `pt-br-sherpa` → `sherpa/pt-br-voice.onnx`).
4. **Gradle configuration**
   - If you use AARs, add them via `implementation files('libs/sherpa-onnx.aar')` and enable `jniLibs` packaging. Ensure `android/app/build.gradle` has `packagingOptions { pickFirst '**/*.so' }` if needed.

### iOS
1. **Download Piper/Sherpa iOS build**
   1. From https://github.com/k2-fsa/sherpa-onnx/releases, download the `sherpa-onnx-ios-xcframework.zip`. Extract to obtain `SherpaOnnx.xcframework` (or similar) with headers.
   2. Piper doesn’t ship prebuilt iOS binaries; follow https://github.com/rhasspy/piper#ios to build using Xcode’s clang toolchain. In short:
      - Install dependencies via `brew install cmake llvm pkg-config`.
      - Clone https://github.com/rhasspy/piper, run `./scripts/build-ios.sh` (per instructions) to generate a static library.
      - Use the same voice model archives from step 1 on Android (downloaded from Piper releases) and keep the `.onnx` + `config.json` files for bundling.
2. **Add frameworks/static libs**
   - Drag the `.xcframework` (or `.a` + headers) into `ios/Runner` in Xcode. Ensure “Add to targets → Runner” is checked.
   - In `Runner` target → **General** → **Frameworks, Libraries, and Embedded Content**, set the new framework to “Embed & Sign.”
3. **Bundle models**
   - Add your `.onnx`/`config.json` files to the Runner project (File → Add Files…) and check “Copy items if needed.” They’ll appear under `Runner/Resources`.
   - Update `Build Phases → Copy Bundle Resources` to ensure the model files ship inside the app bundle.
4. **Bridging header (if needed)**
   - If working with C APIs, create `Runner/Runner-Bridging-Header.h` and import the Sherpa/Piper headers so Swift can call them.

### Documentation & References
- Sherpa ONNX docs: https://k2-fsa.github.io/sherpa/onnx/index.html
- Piper model list: https://rhasspy.github.io/piper-samples/
- Piper build instructions: https://github.com/rhasspy/piper#building

After these assets are in place, proceed with the method-channel coding steps detailed above: register `sherpa_tts` handlers, map `voiceId` to model paths, call the native synthesis APIs, and return WAV/MP3 bytes to Dart. EOF
