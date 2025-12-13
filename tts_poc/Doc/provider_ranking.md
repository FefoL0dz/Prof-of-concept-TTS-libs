# Provider Ranking (Best → Worst)

Based on overall voice naturalness, language coverage, latency, pricing, and ease of integration, the providers are ordered from most recommended to least recommended for typical Flutter TTS projects.

| Rank | Provider | Reasoning |
|------|----------|----------|
| 1 | **Google Cloud TTS** | Highest naturalness, massive language/voice catalog, low latency, strong SSML support. Paid but offers a generous free tier. |
| 2 | **ElevenLabs** | Very natural neural voices, easy API, excellent for premium demos. Paid subscription; language support is limited but quality is top‑notch. |
| 3 | **WellSaid Labs** | Premium voice quality, solid API, good for professional content. Paid plans, limited languages. |
| 4 | **Murf.ai** | Studio‑grade voices, reasonable pricing, decent language set. |
| 5 | **AWS Polly** | Good naturalness, broad language set, low latency, competitive pricing. |
| 6 | **Azure Speech** | Strong SSML, good quality, decent language coverage, competitive pricing. |
| 7 | **Play.ht** | Good quality, easy integration, tiered pricing; language set smaller than the cloud giants. |
| 8 | **Resemble AI** | Custom voice cloning, decent quality, higher cost; useful for brand‑specific voices. |
| 9 | **ResponsiveVoice** | Free tier available, many languages, but voice quality is more robotic. |
| 10 | **Coqui Server** | Free/open‑source, decent quality for many languages, but requires self‑hosting and latency depends on your server. |
| 11 | **MaryTTS** | Open‑source and flexible, but voice quality is limited and it needs setup. |
| 12 | **Embedded Piper** | Offline, good quality for supported languages, but needs model files and native binaries. |
| 13 | **Sherpa ONNX** | Offline, decent quality for a few languages, requires ONNX models. |
| 14 | **Device TTS (flutter_tts)** | Uses the OS‑provided engine; zero setup cost but voice quality and language options depend on the device. |
| 15 | **Espeak NG** | Very low‑quality, robotic voices; only useful as a basic fallback. |
| 16 | **Festival/Flite** | Similar to Espeak, older engines with low naturalness. |

**Notes**
- Rankings assume typical priorities: voice naturalness, language variety, latency, and ease of integration.
- For budget‑constrained projects, free/self‑hosted options (Coqui, MaryTTS) may move higher.
- Offline providers (Embedded Piper, Sherpa ONNX) are placed lower because of limited language support, but they are essential when no network is available.

## Serverless Mobile App Ranking

When building a **serverless mobile app** (no custom backend, only the Flutter client), the most important factors are:
- Minimal client‑side setup (API keys passed via `--dart-define`).
- Low latency over mobile networks.
- Good voice quality without requiring heavy native binaries.
- Reasonable cost for mobile‑scale usage.

### Recommended order for serverless mobile
| Rank | Provider | Why suitable for serverless mobile |
|------|----------|--------------------------------------|
| 1 | **Google Cloud TTS** | Excellent naturalness, massive voice catalog, easy client‑side auth via service‑account JSON. |
| 2 | **AWS Polly** | Low latency, good Portuguese support, straightforward `--dart-define` credentials. |
| 3 | **Azure Speech** | Strong SSML, comparable latency, simple key/region config. |
| 4 | **ElevenLabs** | Premium neural voices, API‑first, works well with mobile clients (though language support is limited). |
| 5 | **WellSaid Labs** | High‑quality voices, API‑only integration, suitable for demos. |
| 6 | **Murf.ai** | Studio‑grade voices, API‑only, reasonable pricing. |
| 7 | **Play.ht** | Easy HTTP API, tiered pricing, good for quick integration. |
| 8 | **ResponsiveVoice** | Free tier available, simple script inclusion, but voice quality is more robotic. |
| 9 | **Coqui Server** | Free/open‑source; requires you to run your own server, but once hosted it behaves like any HTTP API. |
| 10 | **Device TTS (flutter_tts)** | No network needed, uses OS voices; quality depends on device OS. |
| 11 | **Embedded Piper** | Offline, good quality for supported languages, but needs model files bundled with the app. |
| 12 | **Sherpa ONNX** | Offline, limited language set, requires ONNX models packaged in the app. |
| 13 | **Resemble AI** | Supports custom voice cloning but higher cost; placed lower for typical mobile budgets. |
| 14 | **Espeak NG** | Very low‑quality, robotic; only as a last‑resort fallback. |
| 15 | **Festival/Flite** | Similar to Espeak, older engine, low naturalness. |
| 16 | **MaryTTS** | Open‑source server; requires you to host it, adding backend complexity, so lower for pure serverless apps. |

These rankings assume you want the best trade‑off between voice quality, ease of client‑side integration, and cost for a mobile‑only deployment.

## Cost‑Benefit Ranking (Best Value → Worst Value)

When considering price versus voice quality, latency, and feature set, the providers can be ordered by overall value for typical mobile/desktop use.

| Rank | Provider | Approx. Cost* | Value Reasoning |
|------|----------|---------------|----------------|
| 1 | **Google Cloud TTS** | $4‑$16 / M characters (free tier) | High naturalness, huge voice catalog, low latency – excellent ROI. |
| 2 | **AWS Polly** | $4 / M (standard) / $16 / M (neural) | Good quality, broad language support, competitive pricing. |
| 3 | **Azure Speech** | $1‑$4 / M | Strong SSML, decent quality, lower price than Google for similar usage. |
| 4 | **ElevenLabs** | $5‑$20 / month subscription | Premium neural voices, but limited language set; still great value for demos. |
| 5 | **WellSaid Labs** | $30‑$99 / month | Premium quality, higher price – good for professional content but less value for casual use. |
| 6 | **Murf.ai** | $19‑$49 / month | Good quality, reasonable price; sits in mid‑range value. |
| 7 | **Play.ht** | $15‑$30 / month | Decent quality, tiered pricing; value depends on plan. |
| 8 | **ResponsiveVoice** | Free tier limited, paid plans start $9 / mo | Easy to use, but voice quality is more robotic – moderate value. |
| 9 | **Coqui Server** | Free (self‑hosted) + hosting cost | No direct cost, but you must maintain a server – value varies. |
| 10 | **Resemble AI** | $25‑$100 / month | Custom voice cloning adds cost; value for niche use cases. |
| 11 | **Device TTS (flutter_tts)** | Free (OS‑provided) | No cost, but quality depends on device OS – low value for high‑quality needs. |
| 12 | **Embedded Piper** | Free (offline) + model download | No license cost, but requires bundling models; good offline value but limited language. |
| 13 | **Sherpa ONNX** | Free (offline) + model download | Similar to Piper but fewer languages – modest value. |
| 14 | **MaryTTS** | Free (self‑hosted) + server cost | Open‑source but requires setup; lower value for quick projects. |
| 15 | **Espeak NG** | Free | Very robotic; only useful as fallback – low value. |
| 16 | **Festival/Flite** | Free | Older engines, low naturalness – lowest value.

*Pricing is indicative and may vary by region and usage tier. Always verify current rates on the provider’s pricing page.

## Best pt‑BR Mobile App Providers (Ranked)

| Rank | Provider | pt‑BR Voice Support | Reasoning |
|------|----------|--------------------|-----------|
| 1 | **Google Cloud TTS** | ✅ Full‑featured pt‑BR neural & standard voices | Highest naturalness, massive catalog, low latency, easy auth. |
| 2 | **AWS Polly** | ✅ Several pt‑BR voices (standard & neural) | Good quality, low latency, straightforward credentials. |
| 3 | **Azure Speech** | ✅ Few pt‑BR voices (standard) | Strong SSML, reliable latency, simple config. |
| 4 | **ElevenLabs** | ✅ One pt‑BR neural voice | Very natural, API‑first, subscription‑based. |
| 5 | **WellSaid Labs** | ✅ One pt‑BR neural voice | Premium quality, easy HTTP API. |
| 6 | **Murf.ai** | ✅ One pt‑BR neural voice | Studio‑grade, reasonable price. |
| 7 | **Play.ht** | ✅ One pt‑BR neural voice | Good quality, tiered pricing. |
| 8 | **ResponsiveVoice** | ✅ One pt‑BR synthetic voice | Free tier, easy embed, more robotic. |
| 9 | **Coqui Server** | ✅ Community pt‑BR models available | Free/open‑source, self‑hosted; latency depends on server. |
| 10 | **Device TTS (flutter_tts)** | ✅ Uses OS pt‑BR voices | Zero cost, offline, quality varies by device. |
| 11 | **Embedded Piper** | ✅ Offline pt‑BR models (if bundled) | Good offline quality, needs model files. |
| 12 | **Sherpa ONNX** | ✅ Limited pt‑BR support (custom models) | Fully offline, requires ONNX models. |
| 13 | **Resemble AI** | ✅ Custom pt‑BR voice cloning (requires training) | Powerful but expensive. |
| 14 | **MaryTTS** | ✅ Can be trained for pt‑BR (self‑hosted) | Open‑source, needs server and custom data. |
| 15 | **Espeak NG** | ✅ Basic pt‑BR synthesis | Very robotic, low quality. |
| 16 | **Festival/Flite** | ✅ Basic pt‑BR synthesis | Similar to Espeak, low naturalness. |
