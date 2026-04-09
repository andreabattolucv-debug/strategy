---
name: multi-startup-strategy-dashboard
status: in-progress
created: 2026-04-09
updated: 2026-04-09
progress: 0%
prd: .claude/prds/multi-startup-strategy-dashboard.md
github: https://github.com/andreabattolucv-debug/strategy/issues/1
---

# Epic: multi-startup-strategy-dashboard

## Overview
Refactor di index.html da monoprogetto a architettura config-driven multi-startup.
Approccio: minimo codice aggiunto, massimo riuso classi CSS e pattern JS esistenti.
Il file esistente è la base — non si riscrive, si estende chirurgicamente.

## Architecture Decisions
- AD-01: Config array PROJECTS[] in testa al JS — source of truth per ogni startup
- AD-02: Una sola CSS variable --accent sostituisce --pink per il colore brand dinamico
- AD-03: localStorage con chiavi prefissate per progetto (mp_{section}_{projectId})
- AD-04: Sezioni sidebar specifiche usano data-project="mc|pn|all" → show/hide via JS puro
- AD-05: boardType 'audience' riusa classi .sc esistenti — aggiunge solo campi KPI Mindcast

## Technical Approach

### Frontend Components
1. PROJECTS config array — oggetti con id, name, color, logo, channels, geo, boardType, sections, kpiSchema
2. setActiveProject(id) — aggiorna CSS var, header DOM, sidebar visibility, badge counters
3. Project Switcher — 2 tab in cima a .sidebar
4. Audience Card — estensione .sc con riga KPI inline (boardType: 'audience')
5. KPI Table — table editabile inline, dati in localStorage per progetto
6. Retention Cohorts — table W1/W2/W3/W4/W8/W12 con highlight CSS puro
7. Funnel refactor — aggiunge project + assignee ai todo, filtri select

### Backend / Infrastructure
Nessuno. File singolo HTML, static hosting (Vercel).

## Task Breakdown

| # | Task | Dipende da | Parallelizzabile |
|---|------|-----------|-----------------|
| T-01 | Config system + CSS --accent refactor | — | no (base) |
| T-02 | Project switcher sidebar + setActiveProject() | T-01 | no |
| T-03 | Audience board Mindcast (6 card + mock data) | T-02 | sì (con T-04) |
| T-04 | KPI table editabile inline (localStorage) | T-02 | sì (con T-03) |
| T-05 | Retention cohorts table Mindcast | T-02 | sì (con T-03, T-04) |
| T-06 | Funnel refactor (project + assignee + filtri) | T-02 | sì (con T-03) |
| T-07 | QA smoke test PN invariato + MC end-to-end | T-03,T-04,T-05,T-06 | no |

**Stima**: ~4h sviluppo effettivo

## Success Criteria (Technical)
- PROJECTS array definisce ogni startup senza toccare altro codice
- setActiveProject() < 30 righe JS
- Zero nuove classi CSS se una esistente è riutilizzabile
- Dati PN esistenti sopravvivono al primo caricamento post-refactor
- File HTML finale < 1.5x dimensione attuale
