# Azure Speech TTS Provider Implementation Guide

## Prerequisites
1. Azure account with **Speech** service provisioned.
2. Obtain the **Speech service key** and **region** (e.g., `eastus`).

## Steps
1. **Create Speech resource** in the Azure portal → Speech → Add.
2. **Copy the key** (`AZURE_SPEECH_KEY`) and region (`AZURE_SPEECH_REGION`).
3. **Pass the credentials** when launching the app:
   ```bash
   flutter run \
     --dart-define=AZURE_SPEECH_KEY=YOUR_KEY \
     --dart-define=AZURE_SPEECH_REGION=YOUR_REGION
   ```
4. The `AzureSpeechProvider` reads these definitions via `String.fromEnvironment` and will be available in the provider dropdown.

## Verification
- Select **Azure Speech** from the provider list, choose a voice, and press **Speak**.
- Audio should be synthesized by Azure.
