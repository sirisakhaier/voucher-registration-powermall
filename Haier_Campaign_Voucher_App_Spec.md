# AI Build Prompt — Haier Campaign Voucher Registration App

Copy everything below into your coding AI (Claude Code, Cursor, etc.) as the build brief.

---

## 1. What to build

A web app used **in-store on a PC/kiosk** by Power Mall staff to register a customer's
purchase and enroll them in one of two active Haier promotions, so the customer receives
the correct free voucher. Two parts:

1. **Public survey app** — Landing page → select store → select campaign → fill in
   customer + purchase details → submit → confirmation screen with a voucher/reference code.
2. **Admin module** — password-protected. Manage Store/Model dimensions, import/export
   data, view submissions, export/reset data, dashboard.

Language: Thai-first UI (labels, buttons, validation messages), Haier brand theme
(blue #004EA2, white wordmark logo), responsive but optimized for a desktop/kiosk screen.

---

## 2. The two campaigns (business rules)

### Campaign A — "เย็นฉ่ำ แล้วยังเติมความสุขให้ทุกเส้นทาง" (Haier x PTT)
- **Period:** today – 31 Aug 2026
- **Offer:** buy 1 of the 4 eligible AC models → free PTT fuel card worth **500 THB**
- **Eligible models (fixed list, not the full AC catalog):**
  - HSU-09VRRA055BF — UV Cool Smart 9,200 BTU
  - HSU-12VRRA05BF — UV Cool Smart 12,300 BTU
  - HSU-18VRRA05BF — UV Cool Smart 18,000 BTU
  - HSU-12VQEC05 — Clean Cool 12,000 BTU
- **Store scope:** all active stores
- **Reward:** flat 500 THB PTT fuel card (no scaling)

### Campaign B — "Shop More Get More" (Haier x LFC x PSG)
- **Period:** 22 Aug 2026 – 30 Sep 2026
- **Offer:** buy any model(s) from the full Model dimension (no SKU restriction),
  total receipt value ≥ **20,000 THB** → free Gift Voucher The Mall worth **1,000 THB**
- **Eligible models:** all models in the Model dimension (Brand = Haier, Active) — no SKU restriction
- **Store scope:** **only** `PM:SIAM_PARAGON` (S00449) and `PM:EMPORIUM` (S00327) —
  enforce this in the UI (don't just filter store dropdown by campaign; also validate
  server-side, since staff could switch campaign after picking a store)
- **Reward:** flat 1,000 THB Gift Voucher The Mall

> Build both the reward name/value and the eligibility rules (dates, models, stores,
> min. spend) as **data, not hard-coded UI text** — an admin should be able to edit a
> campaign's dates, eligible store list, eligible models, minimum spend, and reward
> description without a code change.

---

## 3. Data model

Seed from the two provided CSVs.

**Dimension_Store** (9 rows, `Dimension_Store.csv`)
`STORE_ID, STORE_NAME, Store Name TH, Province TH, Region TH, Active-Inactive`

**Dimension_Model** (415 rows, `Dimension_Model.csv`)
`Model, Brand, Category, SubCategory, Active-Inactive, Remark, Update by, Update date`

**Campaign** (new table, seed with the 2 campaigns above)
`campaign_id, name_th, name_en, start_date, end_date, eligible_store_ids[], eligible_model_codes[] (empty = all), min_spend_thb, reward_name, reward_value_thb, active`

**Submission** (new table — the survey record; query by `store_id` to power each
store's "show registered data" list)
- `submission_id` (PK, also acts as the voucher reference number shown to the customer)
- `store_id` (FK) — indexed, since each store can accumulate many registrations
- `campaign_id` (FK)
- `customer_name` — **required**
- `customer_phone` — **required**
- `model_code` (FK, single-select for Campaign A; for Campaign B allow one row per
  line item, or a simple "total purchase amount" field — see open question below)
- `purchase_amount_thb` — **required**
- `receipt_no` — for duplicate-claim prevention and any future reconciliation
- `receipt_photo` — **required upload**, proof of purchase, stored in R2
- `staff_name` or `staff_id` — who registered the entry
- `submitted_at`
- `voucher_status` — `pending / issued / rejected`, editable by admin

**Confirmed fields:** customer name, phone, purchase price, and a receipt photo are
all required on every submission, both campaigns. Add any further fields you need
(email, ID, T&C checkbox) on top of this base set.

---

## 4. User flow (public app)

1. **Landing page** — Haier logo + brand theme. Staff select "เลือกสาขา" (select store)
   first.
2. **Store menu** — after picking a store, staff choose between two actions:
   - **"ลงทะเบียนใหม่" (New registration)** → continue to campaign selection → survey
     form, as below.
   - **"ดูรายการที่ลงทะเบียนแล้ว" (Show registered data)** → a list of that store's
     past submissions (searchable/filterable by campaign, date, customer name/phone,
     voucher status), read-only for staff. Since a store can have many registrations,
     this list needs pagination and a search box, not a flat scroll.
3. **Campaign card** — (new-registration path) show campaign name, short terms, and
   reward image (reuse the promo art) so staff can confirm with the customer before
   entering data. Campaign B only selectable at its 2 eligible stores (grey out / hide
   it elsewhere).
4. **Survey form** — customer name, phone, purchase price, and a receipt photo upload
   are always required, on both campaigns. Beyond that, fields adapt to the selected
   campaign:
   - Campaign A: model dropdown limited to the 4 eligible SKUs.
   - Campaign B: model dropdown pulls from the full Model dimension (any Haier model);
     purchase amount must validate ≥ 20,000 THB before allowing submit.
5. **Review & submit** — show a summary, require staff/customer confirmation.
6. **Confirmation screen** — big, kiosk-readable: voucher reference number, reward name
   and value, "แสดงหน้าจอนี้ที่จุดรับของ" (show this screen to redeem) type message.
   Optionally render a QR code of the submission ID for redemption scanning later.
   From here, offer a button back to the store menu (new registration / show all) so
   staff can keep processing the next customer without navigating from scratch.

---

## 5. Admin module

- Login (start with a simple shared password like the TV-survey app's `admin1234`
  pattern; upgrade to per-user accounts later if needed).
- **Dimension management:** view/add/edit/deactivate Store and Model rows; **import**
  (upload the CSV to bulk-replace or upsert) and **export** (download current table as
  CSV) for both.
- **Campaign management:** edit dates, eligible stores/models, min spend, reward text —
  so campaign changes don't need a redeploy.
- **Submissions dashboard:** table + filters (store, campaign, date range, voucher
  status); totals (submissions per campaign, per store, total voucher value issued);
  mark a submission `issued` / `rejected`; **export submissions to CSV**.
- **Data reset:** ability to clear/reset submission data (with confirmation), same as
  the TV-survey app's reset function.

---

## 6. Tech stack

Same stack as the earlier TV-survey app build:
- **Frontend:** static SPA on **Cloudflare Pages**
- **Backend:** **Cloudflare Workers/Functions** for API routes
- **Database:** **Cloudflare D1** for Store/Model/Campaign/Submission tables
- **File storage:** **Cloudflare R2** for receipt photo uploads
- **Source control:** GitHub repo, deploy via Cloudflare Pages CI

---

## 7. Deliverables

- Working app deployed on Cloudflare Pages, with the two CSVs seeded into D1
- Admin module reachable at a distinct route (e.g. `/admin`)
- README covering: local setup, D1 schema/migrations, how to add a new campaign,
  how to re-import Store/Model CSVs
- Brand theme (Haier blue #004EA2 + logo) applied to every screen, matching the
  earlier TV-survey app's styling conventions

---

## Open questions to confirm before/while building
1. Should Campaign B allow **multiple line items** (several models in one receipt) or
   is a single total purchase amount enough?
2. Does the voucher get redeemed digitally (QR scan) or is this purely a registration
   log for offline voucher handout?
