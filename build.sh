#!/bin/bash
# Cloudflare Pages build script
# Generates config.js from environment variables
# 
# Variables en Cloudflare Pages → Settings → Environment Variables:
#   SUPABASE_URL  = https://bcmuwbzepqfztxpdikux.supabase.co  (real — usado por Pages Function)
#   SUPABASE_KEY  = eyJhbGciOi...                              (anon key)
#   ADMIN_KEY     = Humo1502*                                  (admin password)
#
# El frontend usa /api como proxy (Pages Function hace de cache + rate limiter)
# La Pages Function lee SUPABASE_URL real del environment.

if [ -n "$SUPABASE_KEY" ] && [ -n "$ADMIN_KEY" ]; then
  cat > config.js << EOF
// Generated at build time from Cloudflare Pages env vars
// DO NOT edit manually — edit env vars in Cloudflare Dashboard instead
window.SIVIV_CONFIG = {
  supabaseUrl: '/api',   // proxy via Pages Function (cache + rate limit)
  supabaseKey: '$SUPABASE_KEY',
  adminKey: '$ADMIN_KEY',
};
EOF
  echo "✅ config.js generated (proxy mode via /api)"
else
  cp config.example.js config.js
  echo "⚠️  Using example config — set SUPABASE_KEY and ADMIN_KEY in Cloudflare Dashboard"
fi
