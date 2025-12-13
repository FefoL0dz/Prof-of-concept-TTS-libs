# AWS Polly TTS Provider Implementation Guide

## Prerequisites
1. AWS account with **Polly** service enabled.
2. Access keys (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY) and region (AWS_REGION).
3. Optionally, a session token (AWS_SESSION_TOKEN) if using temporary credentials.

## Steps
1. **Create IAM user / role** with `AmazonPollyFullAccess` policy.
2. **Generate Access Keys** and note the values.
3. **Add keys to the app** when launching:
   ```bash
   flutter run \
     --dart-define=AWS_ACCESS_KEY_ID=YOUR_KEY \
     --dart-define=AWS_SECRET_ACCESS_KEY=YOUR_SECRET \
     --dart-define=AWS_REGION=us-east-1
   ```
   If using a session token, also add:
   `--dart-define=AWS_SESSION_TOKEN=YOUR_TOKEN`.
4. The `AwsPollyProvider` reads these definitions via `String.fromEnvironment` and will be available in the provider dropdown.

## Verification
- Select **AWS Polly** from the provider list.
- Choose a voice and press **Speak**.
- Audio should be synthesized by AWS Polly.
