> **Language**: **English** | [Español](Web-Mode-&-CORS-Proxy-ES)

# Web Mode & CORS Proxy

Forsaken supports running in a browser via **EmulatorJS** (`web/emulatorjs/`).

## CORS Proxy Configuration
Browsers block direct cross-origin ROM downloads from external servers unless CORS headers are present.
1. Open **Settings → Web Settings**.
2. Set your **CORS Proxy URL** (e.g. a Cloudflare Worker from `tools/cors-proxy-worker/`).
3. Save settings and launch any supported web platform.
