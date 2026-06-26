# Self-hosting Umami analytics on Fly.io

How `stats.aleahim.com` works: a self-hosted [Umami](https://umami.is) instance
running on [Fly.io](https://fly.io), serving privacy-friendly analytics (and
heatmaps) for a family of sites — for a few dollars a month, with no per-site fee.

This is an explanation and a how-to. It deliberately contains **no passwords,
tokens, or connection strings** — only the architecture and the steps. Operational
secrets live elsewhere, privately.

## Why self-host

Umami Cloud's free tier caps the number of sites. Once you run more than a handful
of small sites, a single self-hosted instance is cheaper and uncapped: you pay for
one tiny server and add as many websites as you like. Umami is open-source, stores
no personal data, needs no cookie banner, and is light enough to run on the
smallest VM.

## The architecture

```
  your sites'  <head>                     stats.aleahim.com  (CNAME)
  <script .../stats.aleahim.com/...> ───►  barcodehq-umami.fly.dev  (Fly app)
                                                   │
                                                   ▼
                                            PostgreSQL  (shared Fly Postgres)
```

- **One Fly app** runs the Umami container.
- **One Postgres database** stores the analytics. To save money it can live in a
  Postgres server you already run for something else (Umami just uses its own
  database/schema there); or you can give it a dedicated Postgres. Either works.
- **A pretty domain** (`stats.aleahim.com`) is a CNAME to the Fly app, so every
  site's beacon points at a stable, branded host instead of the raw `*.fly.dev`.
- **Each website** you track gets a *website-id* in Umami; you drop a one-line
  script tag carrying that id into the site's HTML.

## Fly app configuration

A minimal `fly.toml` for the Umami app:

```toml
app = "barcodehq-umami"
primary_region = "ams"

[build]
  image = "ghcr.io/umami-software/umami:postgresql-latest"

[http_service]
  internal_port = 3000
  force_https = true
  auto_stop_machines = "off"     # analytics must stay up to receive beacons
  auto_start_machines = true
  min_machines_running = 1

[[http_service.checks]]
  interval = "15s"
  timeout  = "10s"
  grace_period = "30s"
  method = "GET"
  path = "/api/heartbeat"

[[vm]]
  size = "shared-cpu-1x"
  memory = "512mb"
```

Notes:
- Umami listens on **port 3000**; the health endpoint is **`/api/heartbeat`**.
- Keep `min_machines_running = 1` and `auto_stop_machines = "off"` — unlike a
  request/response API, an analytics collector must always be awake to receive
  pageview beacons.
- `512mb` on the smallest shared CPU is plenty for a personal fleet of sites.

Umami needs two secrets set on the app (never commit these): a database connection
URL, and an app-level signing secret. Set them with `flyctl secrets set` — by name
only; the values stay on Fly.

## Deploying

```bash
# from the folder holding the fly.toml
flyctl deploy --config deploy/umami/fly.toml -a barcodehq-umami

# health and logs
curl -s https://barcodehq-umami.fly.dev/api/heartbeat
flyctl logs -a barcodehq-umami
```

On first boot Umami creates its tables and a default `admin` user. Log in at the
app URL and **change the admin password immediately**, under Settings → Profile.

## The pretty domain (stats.aleahim.com)

1. In Fly, add the custom hostname:
   `flyctl certs add stats.aleahim.com -a barcodehq-umami`.
2. At your DNS registrar for `aleahim.com`, add a **CNAME**:
   - **Host:** `stats`
   - **Value/Target:** `barcodehq-umami.fly.dev`
   - **TTL:** automatic (or 5 min)
3. Wait for the certificate to go valid (`flyctl certs show stats.aleahim.com
   -a barcodehq-umami`). After that, both the dashboard and the beacon work over
   `https://stats.aleahim.com`.

## Adding a site to track

1. **Create the website in Umami:** dashboard → Settings → Websites → **Add**.
   Give it a name and domain; Umami generates a **website-id** (a UUID). (You can
   also do this via the API: log in to `/api/auth/login`, then `POST /api/websites`;
   the response carries the `website_id`.)
2. **Add the beacon** to that site's HTML `<head>`:
   ```html
   <script defer src="https://stats.aleahim.com/script.js"
           data-website-id="YOUR-WEBSITE-ID"></script>
   ```
3. **Deploy the site.** Pageviews start appearing in the dashboard within a few
   minutes. The script is tiny and `defer`red, so it never blocks rendering — if
   analytics are ever down, your site is unaffected.

## Heatmaps / session replay (optional)

Umami can record heatmaps and session replays. Two things are required:

1. **Enable it for the website** (per-site toggle): in newer Umami this is a
   "Enable session recording" switch in the website's settings; it sets a
   `recorder_enabled` flag and a `replay_config` (e.g. a 15% sample rate) on the
   website record.
2. **Load the recorder script** in addition to the normal one:
   ```html
   <script defer src="https://stats.aleahim.com/script.js"   data-website-id="YOUR-WEBSITE-ID"></script>
   <script defer src="https://stats.aleahim.com/recorder.js" data-website-id="YOUR-WEBSITE-ID"></script>
   ```

Recordings start appearing after new visits (at the configured sample rate).

## Migrating off Umami Cloud

If you're moving from Umami Cloud:

- It's a **forward-only cutover**: change each site's beacon from
  `https://cloud.umami.is/script.js` (+ its old cloud website-id) to your
  self-hosted host (+ the new self-hosted website-id), then redeploy the site.
- Historical data stays in Umami Cloud; new pageviews flow to the self-hosted
  instance. Export the old data first if you want a local archive (Umami's API
  returns stats/pageviews/events as JSON).
- A common gotcha during migration: each site needs the **new** website-id, not the
  old cloud one. Mixing them silently sends data to the wrong place.

## Operating it day to day

- **Health:** `curl https://stats.aleahim.com/api/heartbeat` or the Fly monitoring
  page.
- **Logs:** `flyctl logs -a barcodehq-umami`.
- **Redeploy / upgrade:** bump the image tag (or re-pull `:postgresql-latest`) and
  `flyctl deploy` again.
- **Disk pressure:** analytics tables grow with traffic; old rows can be archived
  (export, then delete by date) if the Postgres volume fills.

## Cost

One `shared-cpu-1x` / 512 MB machine plus a small Postgres comes to roughly a few
dollars a month total, regardless of how many sites you point at it. Compared with
per-site SaaS analytics pricing, a single self-hosted instance pays for itself
quickly once you run more than a couple of sites.
