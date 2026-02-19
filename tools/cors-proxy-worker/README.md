# Forsaken CORS Proxy Worker

A Cloudflare Worker that proxies HTTP requests with CORS headers, enabling the web version of Forsaken to download ROMs from external servers.

## Why?

Browsers enforce CORS (Cross-Origin Resource Sharing) restrictions. ROM download servers typically don't include `Access-Control-Allow-Origin` headers, so the browser blocks direct downloads from the web app. This worker acts as a relay that adds the required CORS headers.

## Setup

### Prerequisites

- A free [Cloudflare account](https://dash.cloudflare.com/sign-up)
- [Node.js](https://nodejs.org/) 18+

### Deploy

```bash
# Install Wrangler (Cloudflare's CLI)
npm install -g wrangler

# Login to your Cloudflare account
wrangler login

# Deploy the worker
cd tools/cors-proxy-worker
npx wrangler deploy
```

After deployment, Wrangler will print the worker URL:

```
Published forsaken-cors-proxy (1.0.0)
  https://forsaken-cors-proxy.<your-subdomain>.workers.dev
```

### Configure in Forsaken

1. Open the web version of Forsaken
2. Go to **Settings > Web Settings**
3. Paste the worker URL (e.g., `https://forsaken-cors-proxy.your-subdomain.workers.dev/`)
4. Click **Test Proxy Connection** to verify
5. Click **Save Settings**

## Usage

The worker proxies GET requests:

```
GET https://your-worker.workers.dev/?url=https://example.com/rom.zip
```

The `url` query parameter specifies the target URL. The worker fetches it server-side (no CORS restrictions on Cloudflare Workers) and returns the response with CORS headers added.

## Limits

- **Free tier**: 100,000 requests/day (more than enough for personal use)
- **Max file size**: 512 MB (configurable in `worker.js`)
- **Methods**: GET only

## Security

- Only HTTP(S) URLs are allowed
- CORS origin can be restricted by editing `ALLOWED_ORIGINS` in `worker.js`
- The worker follows redirects automatically

## Customization

Edit `worker.js` to:

- Restrict allowed origins (`ALLOWED_ORIGINS` array)
- Change max file size (`MAX_CONTENT_LENGTH`)
- Add rate limiting or authentication
