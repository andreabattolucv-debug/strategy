---
name: multi-startup-strategy-dashboard
description: Trasformare la dashboard monoprogetto di Pink Notebook in una piattaforma multi-startup config-driven, aggiungendo Mindcast AI con audience testing board, KPI tracker e funnel condiviso.
status: active
created: 2026-04-09
---

# PRD: multi-startup-strategy-dashboard

## Executive Summary
La dashboard attuale è hardcoded su Pink Notebook (Google Ads / Meta / Pinterest, mercati IT-ME-LV).
Il team di growth hacking gestisce una seconda startup — Mindcast AI — che richiede un framework
di audience testing completamente diverso: 6 segmenti paralleli, canali TikTok/IG Reels/YouTube
Shorts/LinkedIn, KPI specifici (CPD, CPAU, retention W1-W12, paywall conversion, ARPU).
Obiettivo: un'unica app con switch di progetto in sidebar, struttura sezioni condivisa e sezioni
specifiche per startup, config-driven, zero dipendenze aggiuntive.

## Problem Statement
- L'app è monoprogetto: ogni variabile, label e sezione è hardcoded "Pink Notebook"
- Mindcast ha bisogno di audience testing board (non keyword tracking) e KPI diversi
- Il team (Andrea + Mattia) usa lo stesso funnel/todo per entrambe le startup
- Aggiungere una terza startup oggi richiederebbe riscrivere tutto da zero

## User Stories

### US-01 — Project Switch
Come growth hacker, voglio switchare tra Pink Notebook e Mindcast dalla sidebar in un click,
così gestisco entrambi i progetti senza aprire file diversi.
*AC: click sul tab cambia nome header, sezioni sidebar, colore accent e dati — senza reload.*

### US-02 — Audience Board Mindcast
Come growth hacker, voglio vedere le 6 audience Mindcast come card con stato
(testing / validated / failed), così capisco a colpo d'occhio dove siamo nella validazione.
*AC: ogni card mostra nome, CPM range, canali attivi, KPI principali, bottoni Valida/Boccia.*

### US-03 — KPI Tracker Mindcast
Come growth hacker, voglio tracciare CPD, CPAU, retention W1/W4/W8/W12 e paywall conversion
per audience, così posso decidere quali killare e quali scalare.
*AC: tabella KPI con una riga per audience, colonne per KPI, input manuale editabile inline.*

### US-04 — Pink Notebook invariato
Come growth hacker di PN, voglio che keyword tracker, strategy board e negative keywords
funzionino esattamente come prima del refactor.
*AC: zero regressioni sulle sezioni PN esistenti.*

### US-05 — Funnel condiviso con filtri
Come membro del team, voglio vedere i todo del funnel filtrati per startup e assegnatario
(Andrea / Mattia), così so esattamente cosa tocca a me su quale progetto.
*AC: dropdown filtro startup + assegnatario; dati separati in localStorage per progetto.*

### US-06 — Note audience
Come membro del team, voglio aggiungere note a un'audience Mindcast con timestamp e autore,
così il team ha contesto storico su ogni test.
*AC: ogni audience card ha sezione note con timestamp e campo autore (Andrea/Mattia).*

## Functional Requirements

### FR-01 — Project Config System
- Array PROJECTS[] in testa al JS con oggetti config per ogni startup
- Ogni config: id, name, color, logo, channels, geo, boardType ('audience'|'strategy'), sections, kpiSchema
- setActiveProject(id) aggiorna tutto il DOM senza reload

### FR-02 — Sidebar Switch
- Due tab in cima alla sidebar: [PN] [MC]
- Tab attivo = bordo colorato con accent del progetto
- Al click: aggiorna header, CSS accent var, sezioni sidebar, contenuto main

### FR-03 — Strategy Board (shared, comportamento diverso per boardType)
- boardType 'strategy' (PN): funzionamento attuale invariato
- boardType 'audience' (MC): card audience con nome segmento, età, CPM, geo, canali, hook copy, KPI, note
- Stato: testing / validated / failed — riusa classi .sc esistenti
- Bottoni: Valida / Boccia / Note

### FR-04 — KPI & Campaigns (nuovo, condiviso)
- Tabella configurabile da kpiSchema del progetto attivo
- Input inline editabile per ogni cella
- Dati in localStorage per progetto

### FR-05 — Funnel & Site Dev (refactor shared)
- Campo project e assignee su ogni todo
- Filtri: startup + assegnatario
- localStorage separato: mp_todos_pn, mp_todos_mc

### FR-06 — Retention Cohorts (Mindcast-only)
- Tabella: righe = audience, colonne = W1/W2/W3/W4/W8/W12
- Input % inline, highlight verde/rosso vs benchmark
- Nessuna libreria grafica aggiuntiva

### FR-07 — Data Persistence
- Tutto in localStorage, chiavi prefissate per progetto
- Migrazione automatica dati PN esistenti al primo caricamento

## Non-Functional Requirements
- NFR-01: Zero dipendenze aggiuntive — HTML/CSS/JS vanilla puro
- NFR-02: File singolo HTML
- NFR-03: Nessuna API call esterna nella fase 1
- NFR-04: Switch progetto < 50ms
- NFR-05: Mobile-responsive — non rompere breakpoint 900px esistente

## Success Criteria
- [ ] Switch PN/MC in sidebar funziona e cambia tutto il contesto visivo
- [ ] 6 audience Mindcast creabili, modificabili, validabili con localStorage persistence
- [ ] KPI tracker MC mostra CPD, CPAU, W1-W4-W8-W12, paywall conv editabili inline
- [ ] Funnel todos filtrabili per startup e assegnatario
- [ ] Sezioni PN (keyword, strategy, negative KW) funzionano identiche a prima
- [ ] Zero librerie aggiuntive, file singolo HTML

## Constraints & Assumptions
- Fase 1: dati manuali (localStorage) — nessuna integrazione API
- Password unica condivisa (auth attuale invariata)
- Dati mock Mindcast basati sul documento di strategia fornito
- Nessun backend — tutto client-side

## Out of Scope (Fase 1)
- Integrazione API TikTok Ads / Google Ads / Meta per Mindcast
- Login multiutente con credenziali separate
- Export PDF report
- Terza startup (ma l'architettura la supporta)
- Grafici retention (solo tabella)

## Dependencies
- index.html esistente (Pink Notebook dashboard) — da refactorare, non riscrivere
- Documento strategia Mindcast (fornito) — per dati mock iniziali
