# Voucher Registration – Power Mall x Haier

Web app for Power Mall promoters (PC) to register Haier purchases and issue vouchers. UI text is Thai.

## Links
- GitHub: https://github.com/sirisakhaier/voucher-registration-powermall (branch `main`)
- Cloudflare Pages project: `voucher-registration-powermall` (dashboard: https://dash.cloudflare.com/fc46ed25794e10dde0e81a2c2084b860/pages/view/voucher-registration-powermall)
- Live: https://voucher-registration-powermall.pages.dev
- Deploy: Git-connected Pages (push to `main` deploys). Manual: `npx wrangler pages deploy . --project-name=voucher-registration-powermall`

## Stack
- `index.html` (~2,400 lines): single-page app, all JS inline. CDN libs: Tailwind, Lucide, QRCode, Flatpickr (th), ExcelJS, FileSaver. No build step.
- `functions/api/*.js`: Pages Functions
  - `register.js` POST: saves submission to D1 + 2 photos to R2
  - `submissions.js` GET (filter `store_id`) / PUT (audit status) / DELETE (single, or all with `confirmation=CONFIRM-RESET`)
  - `dimensions.js` GET stores/models/campaigns
  - `image/[[path]].js` GET image from R2 (fallback D1)
- `migrations/0001_init.sql`: schema + seed (tables `dimension_store`, `dimension_model`, `campaigns`, `submissions`; 8 stores, 415 SKUs, 2 campaigns)
- `wrangler.toml`: D1 `DB` = `voucher-db` (id `dd94f98f-2ecd-4951-8fd3-7e75969793a6`), R2 `BUCKET` = `voucher-photos`
- Source data / specs: `Dimension Store|Model .csv/.json`, `Haier_Campaign_Voucher_App_Spec.md`, `Voucher_Registration_PowerMall.md`, poster images `Ad AC PTT vc.png`, `Ad PM vc.jpg`. README.md has full feature docs.

## Campaigns (seeded in `campaigns`)
- A `CAMP-2026-PTT-AC`: Haier x PTT, PTT card 500 THB, 4 inverter AC models, all 8 stores
- B `CAMP-2026-SPORTS-MALL`: Shop More Get More, Gift Voucher The Mall 1,000 THB, any Haier category, spend >= 20,000 THB, all stores

## Known issues / gotchas
- Admin password `admin1234` is hard-coded and checked client-side in `index.html` (~line 1867). The admin API endpoints (PUT/DELETE/GET all) have no server-side auth, so anyone can call them. Should move to a server-checked token secret.
- Admin password issue above is still open (deliberately not changed yet).

## Workflows
- **Tailwind is compiled**, not CDN. After adding/changing Tailwind classes in `index.html` (or theme colors in `tailwind.config.js`), run `npm run build:css` and commit `tailwind.css` (Pages has no build step).
- **Update stores/models**: edit `Dimension Store.csv` / `Dimension Model.csv` (Active-Inactive column), then `npm run dims:push` (generates `migrations/dimensions_sync.sql` and applies it to remote D1; `dims:push:local` for local). Rows removed from the CSV are deactivated, never deleted. Campaigns are still edited in SQL (seed in `0001_init.sql`; add a new migration for changes).
- **Photos**: full images go to R2 `receipts/` and `vouchers/`; the browser also makes ~160px thumbs stored at `thumbs/{id}_receipt|voucher.jpg`. Admin/browse lists use `thumbSrc()`/`thumbImg()` (thumbs only; records from before 2026-09-30 have no thumb and show a placeholder, click opens the full photo). Excel export still fetches full images.
- Campaign A model list lives in 3 places: `CAMPAIGNS` and the landing badges in `index.html`, and `campaigns.eligible_model_codes` in D1 (migration `0002`).
- `npm run dev` / scripts now use the production names `voucher-db` / `voucher-photos`.
- CDN libs are version-pinned (lucide 1.49.0, flatpickr 4.6.13, qrcode, exceljs, file-saver).
- `.wrangler/` is gitignored (local state only).
