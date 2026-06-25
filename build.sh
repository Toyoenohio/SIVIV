#!/bin/bash
# Cloudflare Pages build script
# Generates config.js from environment variables
# Set SUPABASE_URL and SUPABASE_KEY in Cloudflare Pages → Settings → Environment Variables

if [ -n "$SUPABASE_URL" ] && [ -n "$SUPABASE_KEY" ] && [ -n "$ADMIN_KEY" ]; then
  sed "s|{{SUPABASE_URL}}|$SUPABASE_URL|g; s|{{SUPABASE_KEY}}|$SUPABASE_KEY|g; s|{{ADMIN_KEY}}|$ADMIN_KEY|g" config.template.js > config.js
  echo "✅ config.js generated from environment variables"
else
  # Fallback: use config.example.js if env vars not set
  cp config.example.js config.js
  echo "⚠️  Using example config — replace with real credentials"
fi
