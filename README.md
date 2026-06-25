# SIVIV — Sistema de Información de Víctimas

Registro y búsqueda de personas afectadas por el terremoto en Venezuela.  
App ligera (Vue 3 + Supabase + Tailwind CDN), sin build step, sin dependencias.

## Estructura

| Archivo | Acceso | Descripción |
|---|---|---|
| `index.html` | 🌐 Público | Buscador y registro individual |
| `admin.html` | 🔒 Admin | Carga masiva CSV + panel de control |
| `setup.sql` | — | Creación de tabla en Supabase |
| `config.example.js` | 📋 Template | Credenciales de ejemplo |
| `config.js` | 🚫 Gitignored | Credenciales reales |

## Configuración

### 1. Base de datos
Ejecuta `setup.sql` en tu Supabase SQL Editor.

### 2. Credenciales
Copia `config.example.js` → `config.js` y completa:

```js
window.SIVIV_CONFIG = {
  supabaseUrl: 'https://xxxxx.supabase.co',
  supabaseKey: 'TU_ANON_KEY',
  adminKey: 'tu-clave-secreta',
};
```

### 3. Deploy

**Cloudflare Pages (recomendado):**
- Build command: `bash build.sh`
- Output directory: `/`
- Env vars: `SUPABASE_URL`, `SUPABASE_KEY`, `ADMIN_KEY`

## CSV formato

```csv
nombre,apellido,edad,cedula,centro
María,González,34,V-12345678,Hospital Central
Carlos,Rodríguez,45,,Clínica La Floresta
```

La app autodetecta las columnas por nombre (soporta variantes como "nombres", "age", "cédula", "hospital", etc). Si los nombres no coinciden, puedes mapearlos manualmente en el panel.
