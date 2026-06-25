# SIVIV — Sistema de Información de Víctimas

Registro y búsqueda de personas afectadas por el terremoto en Venezuela. App ligera (Vue 3 + Supabase), sin build step.

## Configuración

1. Ejecuta `setup.sql` en tu Supabase SQL Editor
2. Copia tu **Project URL** y **anon key** de Supabase → Settings → API
3. Reemplázalas en `index.html` (líneas ~180):
   ```js
   supabaseUrl: 'https://TU_PROJECT_ID.supabase.co',
   supabaseKey: 'TU_ANON_KEY',
   ```
4. Haz deploy en Cloudflare Pages o GitHub Pages

## Deploy

### Cloudflare Pages (recomendado)
1. Conecta este repo en Cloudflare Pages
2. Build command: *vacío* (es HTML estático)
3. Output directory: `/` (root)

### GitHub Pages
Settings → Pages → Source: main branch, root folder

## Uso

- **Buscar**: Escribe nombre/apellido/cédula — filtra instantáneamente
- **Registrar**: Formulario para añadir personas. Acceso abierto.
