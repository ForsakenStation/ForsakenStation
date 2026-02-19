/**
 * Forsaken Emulator - CORS Proxy Worker
 *
 * A Cloudflare Worker that proxies requests adding CORS headers.
 * Used by the web version to download ROMs from external servers
 * that don't include Access-Control-Allow-Origin headers.
 *
 * Deploy: https://developers.cloudflare.com/workers/get-started/guide/
 *
 * Usage:
 *   GET https://your-worker.your-subdomain.workers.dev/?url=https://example.com/rom.zip
 *
 * Configure the deployed URL in Forsaken Settings > Web > CORS Proxy URL.
 */

// Optional: restrict to specific origins (empty = allow all)
const ALLOWED_ORIGINS = [];

// Max file size (512 MB) - adjust as needed
const MAX_CONTENT_LENGTH = 512 * 1024 * 1024;

export default {
  async fetch(request) {
    // Handle preflight (OPTIONS)
    if (request.method === 'OPTIONS') {
      return handleCORS(new Response(null, { status: 204 }), request);
    }

    // Only allow GET
    if (request.method !== 'GET') {
      return handleCORS(
        new Response('Method not allowed', { status: 405 }),
        request,
      );
    }

    // Extract target URL from query parameter
    const url = new URL(request.url);
    const targetUrl = url.searchParams.get('url');

    if (!targetUrl) {
      return handleCORS(
        new Response(
          JSON.stringify({
            error: 'Missing "url" query parameter',
            usage: 'GET /?url=https://example.com/file.zip',
          }),
          {
            status: 400,
            headers: { 'Content-Type': 'application/json' },
          },
        ),
        request,
      );
    }

    // Validate URL
    let parsedUrl;
    try {
      parsedUrl = new URL(targetUrl);
      if (!['http:', 'https:'].includes(parsedUrl.protocol)) {
        throw new Error('Only HTTP(S) URLs are allowed');
      }
    } catch (e) {
      return handleCORS(
        new Response(JSON.stringify({ error: `Invalid URL: ${e.message}` }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        }),
        request,
      );
    }

    try {
      // Fetch the target URL (Cloudflare Workers have no CORS restrictions)
      const targetResponse = await fetch(targetUrl, {
        headers: {
          'User-Agent': 'ForsakenEmulator-CORSProxy/1.0',
          Accept: '*/*',
        },
        redirect: 'follow',
      });

      // Check content length
      const contentLength = parseInt(
        targetResponse.headers.get('content-length') || '0',
        10,
      );
      if (contentLength > MAX_CONTENT_LENGTH) {
        return handleCORS(
          new Response(
            JSON.stringify({
              error: `File too large: ${contentLength} bytes (max ${MAX_CONTENT_LENGTH})`,
            }),
            {
              status: 413,
              headers: { 'Content-Type': 'application/json' },
            },
          ),
          request,
        );
      }

      // Forward the response with CORS headers
      const response = new Response(targetResponse.body, {
        status: targetResponse.status,
        statusText: targetResponse.statusText,
        headers: {
          'Content-Type':
            targetResponse.headers.get('Content-Type') ||
            'application/octet-stream',
          'Content-Length':
            targetResponse.headers.get('Content-Length') || '',
          'Content-Disposition':
            targetResponse.headers.get('Content-Disposition') || '',
          'Cache-Control': 'public, max-age=86400',
        },
      });

      return handleCORS(response, request);
    } catch (e) {
      return handleCORS(
        new Response(
          JSON.stringify({ error: `Fetch failed: ${e.message}` }),
          {
            status: 502,
            headers: { 'Content-Type': 'application/json' },
          },
        ),
        request,
      );
    }
  },
};

/**
 * Add CORS headers to a response
 */
function handleCORS(response, request) {
  const origin = request.headers.get('Origin') || '*';

  // Check allowed origins
  if (
    ALLOWED_ORIGINS.length > 0 &&
    origin !== '*' &&
    !ALLOWED_ORIGINS.includes(origin)
  ) {
    return new Response('Origin not allowed', { status: 403 });
  }

  const headers = new Headers(response.headers);
  headers.set(
    'Access-Control-Allow-Origin',
    ALLOWED_ORIGINS.length > 0 ? origin : '*',
  );
  headers.set('Access-Control-Allow-Methods', 'GET, OPTIONS');
  headers.set('Access-Control-Allow-Headers', 'Content-Type, Range');
  headers.set('Access-Control-Expose-Headers', 'Content-Length, Content-Range');
  headers.set('Access-Control-Max-Age', '86400');

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}
