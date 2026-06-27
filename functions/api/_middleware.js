/**
 * SIVIV — Pages Function proxy para Supabase
 * 
 * Intercepta /api/rest/v1/* → cachea GET → forward al Supabase real.
 * Las credenciales van en Cloudflare Dashboard → Pages → Settings → Environment Variables.
 * 
 * Variables esperadas:
 *   SUPABASE_URL      = https://bcmuwbzepqfztxpdikux.supabase.co
 *   SUPABASE_KEY      = eyJhbGciOi... (anon key)
 */

// Rate limiting en memoria (resetea en cold start — aceptable para emergencia)
const RATE_MAP = new Map();
const RATE_MAX = 30;   // requests por minuto por IP
const RATE_WIN = 60_000;

export async function onRequest(context) {
  const { request, env } = context;
  const url = new URL(request.url);
  const ip = request.headers.get('cf-connecting-ip') || 'unknown';
  const now = Date.now();

  // ── Rate limit ──
  let hits = RATE_MAP.get(ip) || [];
  hits = hits.filter(t => t > now - RATE_WIN);
  if (hits.length >= RATE_MAX) {
    return new Response(JSON.stringify({ error: 'rate_limited', retry_after: Math.ceil((hits[0] + RATE_WIN - now) / 1000) }), {
      status: 429,
      headers: { 'content-type': 'application/json' }
    });
  }
  hits.push(now);
  RATE_MAP.set(ip, hits);

  // GC ocasional
  if (Math.random() < 0.01) {
    for (const [k, v] of RATE_MAP) {
      if (v.every(t => t <= now - RATE_WIN)) RATE_MAP.delete(k);
    }
  }

  // ── Construir URL real de Supabase ──
  const realUrl = url.pathname.replace('/api', '') + url.search;
  const supabaseUrl = env.SUPABASE_URL + realUrl;

  const isRead = request.method === 'GET' || request.method === 'HEAD';
  const cacheKey = new Request(supabaseUrl, { method: request.method });

  // ── GET: intentar cache ──
  if (isRead) {
    const cache = caches.default;
    let resp = await cache.match(cacheKey);
    
    if (resp) {
      resp = new Response(resp.body, resp);
      resp.headers.set('x-siviv-cache', 'HIT');
      return resp;
    }

    resp = await fetch(supabaseUrl, {
      method: request.method,
      headers: {
        'apikey': env.SUPABASE_KEY,
        'authorization': `Bearer ${env.SUPABASE_KEY}`,
        'content-type': 'application/json',
        'prefer': request.headers.get('prefer') || '',
      }
    });

    if (resp.ok) {
      const cached = new Response(resp.body, resp);
      cached.headers.set('cache-control', 'public, max-age=60');
      cached.headers.set('x-siviv-cache', 'MISS');
      context.waitUntil(cache.put(cacheKey, cached.clone()));
      return cached;
    }
    
    return resp;
  }

  // ── POST/DELETE/PATCH: forward sin cache ──
  const body = ['GET', 'HEAD'].includes(request.method) ? undefined : await request.text();

  return fetch(supabaseUrl, {
    method: request.method,
    headers: {
      'apikey': env.SUPABASE_KEY,
      'authorization': `Bearer ${env.SUPABASE_KEY}`,
      'content-type': 'application/json',
      'prefer': request.headers.get('prefer') || '',
    },
    body,
  });
}
