# Pink Notebook — Ads Strategy Dashboard

Internal tool for tracking and validating Google Ads strategies and keywords across Sicily, Montenegro, and Latvia.

## Features

- **Keyword Tracker** — track all keywords with status (testing / winner / loser / negative), CPC, clicks, leads, notes
- **Strategy Board** — validate or discard advertising strategies per market, mark as template when proven
- **Negative Keywords** — manage negative keyword lists by category, copy directly to Google Ads Editor
- **Overview** — campaign health metrics, market breakdown, activity log

## Password

Default: `pinknotebook2025`

To change: open `index.html` and edit the `PASSWORD` constant at the top of the `<script>` block.

## Deploy to Vercel (3 steps)

### Option A — Vercel CLI

```bash
npm i -g vercel
vercel --prod
```

### Option B — GitHub + Vercel (recommended)

1. Create a new GitHub repo (e.g. `pn-ads-dashboard`)
2. Push this folder:
   ```bash
   git init
   git add .
   git commit -m "init dashboard"
   git remote add origin https://github.com/YOUR_USERNAME/pn-ads-dashboard.git
   git push -u origin main
   ```
3. Go to [vercel.com](https://vercel.com) → New Project → Import from GitHub → select repo → Deploy

No build step, no dependencies. Vercel detects it as a static site automatically.

## Data storage

All data is stored in the browser's `localStorage` under the key `pn_dashboard_v2`. This means:
- Each user/browser has independent data
- Data persists across sessions on the same browser
- To reset to demo data: open browser DevTools → Application → localStorage → delete `pn_dashboard_v2`

## Future: Google Ads API integration

The data structure is designed to connect to the Google Ads API. Each keyword has an `id` field that can be mapped to a Google Ads keyword ID. When ready to integrate:

1. Replace `DEFAULT_DATA` with an API fetch on init
2. Replace `save()` with a POST to your backend
3. The UI layer needs zero changes

## Structure

```
index.html     — complete single-file app (HTML + CSS + JS)
vercel.json    — Vercel routing config
README.md      — this file
```
