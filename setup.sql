-- ═══════════════════════════════════════════════
-- SIVIV — Setup completo de base de datos
-- Pegar en: Supabase SQL Editor
-- https://bcmuwbzepqfztxpdikux.supabase.co → SQL Editor
-- ═══════════════════════════════════════════════

-- 1. Tabla de pacientes
CREATE TABLE IF NOT EXISTS public.pacientes (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre TEXT NOT NULL,
  apellido TEXT NOT NULL,
  edad INTEGER,
  cedula TEXT,
  centro TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Índices
CREATE INDEX IF NOT EXISTS idx_pacientes_nombre ON public.pacientes (nombre);
CREATE INDEX IF NOT EXISTS idx_pacientes_apellido ON public.pacientes (apellido);
CREATE INDEX IF NOT EXISTS idx_pacientes_centro ON public.pacientes (centro);

-- 3. Seguridad: acceso público (contexto de emergencia)
ALTER TABLE public.pacientes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "lectura_publica" ON public.pacientes FOR SELECT USING (true);
CREATE POLICY "registro_publico" ON public.pacientes FOR INSERT WITH CHECK (true);
CREATE POLICY "admin_delete"    ON public.pacientes FOR DELETE USING (true);

-- 4. Índices de búsqueda optimizada
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_pacientes_nombre_trgm   ON pacientes USING GIN (nombre gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_pacientes_apellido_trgm ON pacientes USING GIN (apellido gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_pacientes_cedula ON pacientes (cedula);
ANALYZE pacientes;
