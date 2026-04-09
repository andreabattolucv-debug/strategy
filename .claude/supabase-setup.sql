-- ══════════════════════════════════════════════════════════════════════════════
-- Strategy Dashboard — Supabase Setup SQL
-- Run this once in your Supabase SQL editor after creating the project.
-- ══════════════════════════════════════════════════════════════════════════════

-- ── TABLES ────────────────────────────────────────────────────────────────────

CREATE TABLE keywords (
  id          TEXT PRIMARY KEY,
  text        TEXT NOT NULL,
  market      TEXT,
  funnel      TEXT,
  cpc         NUMERIC,
  match_type  TEXT,
  clicks      INT DEFAULT 0,
  leads       INT DEFAULT 0,
  status      TEXT DEFAULT 'testing',
  notes       TEXT,
  ts          BIGINT,
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE strategies (
  id          TEXT PRIMARY KEY,
  title       TEXT NOT NULL,
  market      TEXT,
  demand      TEXT,
  platform    TEXT,
  start_date  TEXT,
  end_date    TEXT,
  why         TEXT,
  persona     TEXT,
  mindset     TEXT,
  body        TEXT,
  copy        TEXT,
  lp          TEXT,
  funnel      TEXT,
  status      TEXT DEFAULT 'testing',
  ts          BIGINT,
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE negatives (
  id          SERIAL PRIMARY KEY,
  category    TEXT NOT NULL,
  keyword     TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(category, keyword)
);

CREATE TABLE audiences (
  id          TEXT PRIMARY KEY,
  name        TEXT NOT NULL,
  segment     TEXT,
  age_range   TEXT,
  cpm_range   TEXT,
  geo         TEXT,
  channels    TEXT[],
  hook        TEXT,
  status      TEXT DEFAULT 'testing',
  kpi         JSONB DEFAULT '{}',
  notes       JSONB DEFAULT '[]',
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE todos (
  id          TEXT PRIMARY KEY,
  project_id  TEXT NOT NULL,
  title       TEXT NOT NULL,
  description TEXT,
  status      TEXT DEFAULT 'todo',
  category    TEXT,
  start_date  TEXT,
  due_date    TEXT,
  assignee    TEXT DEFAULT 'team',
  ts          BIGINT,
  created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE kpi_data (
  id          SERIAL PRIMARY KEY,
  project_id  TEXT NOT NULL,
  row_key     TEXT NOT NULL,
  col_key     TEXT NOT NULL,
  value       TEXT,
  updated_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(project_id, row_key, col_key)
);

CREATE TABLE retention_data (
  id          SERIAL PRIMARY KEY,
  audience_id TEXT NOT NULL,
  week        TEXT NOT NULL,
  value       TEXT,
  updated_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(audience_id, week)
);

CREATE TABLE focus_notes (
  id          SERIAL PRIMARY KEY,
  project_id  TEXT NOT NULL UNIQUE,
  content     TEXT DEFAULT '',
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ── ROW LEVEL SECURITY ────────────────────────────────────────────────────────
-- All tables: authenticated users can do everything

ALTER TABLE keywords       ENABLE ROW LEVEL SECURITY;
ALTER TABLE strategies     ENABLE ROW LEVEL SECURITY;
ALTER TABLE negatives      ENABLE ROW LEVEL SECURITY;
ALTER TABLE audiences      ENABLE ROW LEVEL SECURITY;
ALTER TABLE todos          ENABLE ROW LEVEL SECURITY;
ALTER TABLE kpi_data       ENABLE ROW LEVEL SECURITY;
ALTER TABLE retention_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE focus_notes    ENABLE ROW LEVEL SECURITY;

CREATE POLICY "auth_all" ON keywords       FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON strategies     FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON negatives      FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON audiences      FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON todos          FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON kpi_data       FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON retention_data FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_all" ON focus_notes    FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── REALTIME ─────────────────────────────────────────────────────────────────
-- Enable realtime publication for live sync between users

ALTER PUBLICATION supabase_realtime ADD TABLE keywords;
ALTER PUBLICATION supabase_realtime ADD TABLE strategies;
ALTER PUBLICATION supabase_realtime ADD TABLE negatives;
ALTER PUBLICATION supabase_realtime ADD TABLE audiences;
ALTER PUBLICATION supabase_realtime ADD TABLE todos;
ALTER PUBLICATION supabase_realtime ADD TABLE kpi_data;
ALTER PUBLICATION supabase_realtime ADD TABLE retention_data;
ALTER PUBLICATION supabase_realtime ADD TABLE focus_notes;

-- ── SETUP COMPLETE ────────────────────────────────────────────────────────────
-- After running this SQL:
-- 1. Go to Authentication > Users in Supabase and create users for Andrea and Mattia
--    (email + password, they can change password later via Supabase dashboard)
-- 2. Copy your Supabase project URL and anon key from Settings > API
-- 3. Paste them in index.html at SB_URL and SB_KEY constants
-- 4. Push to GitHub — Vercel will auto-deploy
-- 5. On first login, all existing localStorage data will be seeded to Supabase automatically
