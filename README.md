# SIVIV — Sistema de Información de Víctimas

Registro y búsqueda de personas afectadas por el terremoto en Venezuela.  
App ligera (Vue 3 + Supabase + Tailwind CDN), sin build step, sin dependencias.

## Configuración (3 pasos)

### 1. Base de datos
Ejecuta `setup.sql` en tu Supabase SQL Editor.

### 2. Credenciales

**Opción A — Cloudflare Pages (recomendado):**
1. En Cloudflare Pages → Settings → Environment Variables, agrega:
   - `SUPABASE_URL` = `https://xxxxx.supabase.co`
   - `SUPABASE_KEY` = tu anon key
2. Build command: `bash build.sh`
3. Output directory: `/` (root)

**Opción B — Manual:**
1. Copia `config.example.js` → `config.js`
2. Reemplaza los placeholders con tus credenciales reales
3. `config.js` está en `.gitignore` — **nunca se sube al repo**

### 3. Deploy

- **Cloudflare Pages**: Conecta el repo, configura build como arriba.
- **GitHub Pages**: Settings → Pages → Source: main. Asegúrate de tener `config.js` creado localmente.
- **Vercel**: Importa el repo. Agrega env vars y usa `bash build.sh` como build command.

## Uso

- 🔍 **Buscar**: Escribe nombre/apellido/cédula — filtra instantáneamente
- ➕ **Registrar**: Formulario para añadir personas (acceso abierto — contexto de emergencia)
- 🔄 Auto-refresh cada 60 segundos. Botón manual disponible.
