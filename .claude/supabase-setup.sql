-- ══════════════════════════════════════════════════════════════════════════════
-- Strategy Dashboard — Supabase Setup SQL (idempotent — safe to re-run)
-- ══════════════════════════════════════════════════════════════════════════════

-- ── TABLES ────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS keywords (
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

CREATE TABLE IF NOT EXISTS strategies (
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

CREATE TABLE IF NOT EXISTS negatives (
  id          SERIAL PRIMARY KEY,
  category    TEXT NOT NULL,
  keyword     TEXT NOT NULL,
  created_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(category, keyword)
);

CREATE TABLE IF NOT EXISTS audiences (
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

CREATE TABLE IF NOT EXISTS todos (
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

CREATE TABLE IF NOT EXISTS kpi_data (
  id          SERIAL PRIMARY KEY,
  project_id  TEXT NOT NULL,
  row_key     TEXT NOT NULL,
  col_key     TEXT NOT NULL,
  value       TEXT,
  updated_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(project_id, row_key, col_key)
);

CREATE TABLE IF NOT EXISTS retention_data (
  id          SERIAL PRIMARY KEY,
  audience_id TEXT NOT NULL,
  week        TEXT NOT NULL,
  value       TEXT,
  updated_at  TIMESTAMPTZ DEFAULT now(),
  UNIQUE(audience_id, week)
);

CREATE TABLE IF NOT EXISTS focus_notes (
  id          SERIAL PRIMARY KEY,
  project_id  TEXT NOT NULL UNIQUE,
  content     TEXT DEFAULT '',
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ── ROW LEVEL SECURITY ────────────────────────────────────────────────────────

ALTER TABLE keywords       ENABLE ROW LEVEL SECURITY;
ALTER TABLE strategies     ENABLE ROW LEVEL SECURITY;
ALTER TABLE negatives      ENABLE ROW LEVEL SECURITY;
ALTER TABLE audiences      ENABLE ROW LEVEL SECURITY;
ALTER TABLE todos          ENABLE ROW LEVEL SECURITY;
ALTER TABLE kpi_data       ENABLE ROW LEVEL SECURITY;
ALTER TABLE retention_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE focus_notes    ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "auth_all" ON keywords       FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON strategies     FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON negatives      FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON audiences      FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON todos          FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON kpi_data       FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON retention_data FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "auth_all" ON focus_notes    FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- ── REALTIME ─────────────────────────────────────────────────────────────────

ALTER PUBLICATION supabase_realtime ADD TABLE keywords;
ALTER PUBLICATION supabase_realtime ADD TABLE strategies;
ALTER PUBLICATION supabase_realtime ADD TABLE negatives;
ALTER PUBLICATION supabase_realtime ADD TABLE audiences;
ALTER PUBLICATION supabase_realtime ADD TABLE todos;
ALTER PUBLICATION supabase_realtime ADD TABLE kpi_data;
ALTER PUBLICATION supabase_realtime ADD TABLE retention_data;
ALTER PUBLICATION supabase_realtime ADD TABLE focus_notes;

-- ── T-001: project_integrations + campaign_links ──────────────────────────────

CREATE TABLE IF NOT EXISTS project_integrations (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id      TEXT NOT NULL,
  platform        TEXT NOT NULL DEFAULT 'meta',
  ad_account_id   TEXT NOT NULL,
  access_token    TEXT NOT NULL,
  dashboard_type  TEXT DEFAULT 'ecommerce',
  updated_at      TIMESTAMPTZ DEFAULT now(),
  UNIQUE(project_id, platform)
);

ALTER TABLE project_integrations ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "auth_all_integrations" ON project_integrations
    FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE TABLE IF NOT EXISTS campaign_links (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id     TEXT NOT NULL,
  platform       TEXT NOT NULL DEFAULT 'meta',
  campaign_id    TEXT NOT NULL,
  campaign_name  TEXT,
  strategy_id    TEXT NOT NULL,
  created_at     TIMESTAMPTZ DEFAULT now(),
  UNIQUE(project_id, platform, campaign_id)
);

ALTER TABLE campaign_links ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "auth_all_links" ON campaign_links
    FOR ALL TO authenticated USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

ALTER PUBLICATION supabase_realtime ADD TABLE project_integrations;
ALTER PUBLICATION supabase_realtime ADD TABLE campaign_links;
