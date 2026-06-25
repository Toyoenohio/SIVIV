-- Ejecutar en el SQL Editor de Supabase
-- https://app.supabase.com → tu proyecto → SQL Editor

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
