-- ═══════════════════════════════════════════════
-- SIVIV — Índices de búsqueda optimizada
-- Pegar en: Supabase SQL Editor
-- https://bcmuwbzepqfztxpdikux.supabase.co → SQL Editor
-- ═══════════════════════════════════════════════

-- 1. Extensión pg_trgm (búsqueda difusa de substrings)
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 2. Índices GIN para ILIKE rápido en nombres
CREATE INDEX IF NOT EXISTS idx_pacientes_nombre_trgm   ON pacientes USING GIN (nombre gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_pacientes_apellido_trgm ON pacientes USING GIN (apellido gin_trgm_ops);

-- 3. Índice para búsqueda exacta de cédula
CREATE INDEX IF NOT EXISTS idx_pacientes_cedula ON pacientes (cedula);

-- 4. Actualizar estadísticas
ANALYZE pacientes;
