> The Google provider is reading assets/credentials.json and trying to build ServiceAccountCredentials from it. The placeholder file in the repo still uses dummy values, so
when the SDK dereferences private_key it sees malformed DER bytes (Unexpected tag 68). Replace that asset with a real service-account JSON downloaded from Google Cloud, or
move auth server-side and have the app request a token instead.

To get past the error on-device:

1. In GCP, create a service account with the Text-to-Speech role, generate a key (JSON), and download it locally.
2. Overwrite assets/credentials.json with that file (make sure the PEM block is intact; lines must include the literal -----BEGIN PRIVATE KEY----- / END).
3. Run flutter pub get once so Flutter re-bundles the asset, then flutter run -d <device> again.

If you don’t want secrets in the app bundle, the alternative is to host a lightweight backend that exchanges your service-account key for a short-lived token and have
GoogleCloudTtsProvider call that endpoint instead of reading from assets. But either way, until the provider receives valid credentials it will throw this DER exception and
be filtered out of the dropdown.

Google Cloud Text-to-Speech itself isn’t entirely “free forever,” but Google does offer a very generous no-charge tier: up to 4 million characters/month with standard or
WaveNet voices and 1 million characters/month with Neural2 voices. That’s usually enough for prototyping or even light production use at zero cost. Once you exceed those
quotas, it switches to pay‑as‑you‑go (roughly $16 per 1M chars for Neural2). If you want to avoid Cloud costs altogether, stick with the on-device/Sherpa/Piper options or
self-hosted Coqui/Piper engines, which are fully free beyond your infrastructure.


> I can’t actually ship the native Sherpa/Piper integration from here because it requires platform-specific dependencies and runtime libraries that aren’t present in your repo
(the SherpaTTS/Piper binaries plus model files, and the associated JNI/Obj‑C/C++ wrappers). Without those assets and build scripts I’d be stubbing method channels that still
throw MissingPluginException. The plan in native_impl_plan.md outlines the exact steps—you’ll need to:

1. Add the Sherpa/Piper native libraries and voice models to android/app and ios/Runner.
2. Implement the sherpa_tts MethodChannel handlers in MainActivity and AppDelegate, wiring them to the actual native synthesis calls (encoding to WAV/MP3 before returning
   bytes).
3. Only after those native pieces exist can SherpaTtsProvider receive real audio data.

Once you have the native runtime and models added, I can help wire up the Kotlin/Swift/Obj‑C channel handlers; just let me know when the native code or binaries are in place.