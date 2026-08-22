# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)

ระบบเว็บแอปพลิเคชัน Full-Stack สมัยใหม่ สำหรับ **พนักงานขาย (PC/Promoter) ประจำจุดขาย ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบเงื่อนไขโปรโมชั่นแบบ Real-time แนบหลักฐานภาพถ่าย 2 รายการ และบันทึกข้อมูลเข้าสู่ฐานข้อมูลกลาง **Cloudflare D1 (SQL Database)** พร้อมจัดเก็บรูปภาพใน **Cloudflare R2 (Object Storage)**

---

## 🚀 ลิงก์ระบบใช้งานจริง (Live Production)
- **Production URL:** [https://voucher-registration-powermall.pages.dev](https://voucher-registration-powermall.pages.dev)
- **GitHub Repository:** [https://github.com/sirisakhaier/voucher-registration-powermall](https://github.com/sirisakhaier/voucher-registration-powermall)

---

## 🌟 ฟังก์ชันหลักของระบบ (Core Features)

### 1. 🏪 หน้าแรก (Landing Page) & การลงชื่อเข้าจุดบริการ (PC Check-In)
- **แสดงโปสเตอร์โปรโมชั่น 2 แคมเปญเด่นชัด:** โปสเตอร์ `Haier x PTT` และ `Shop More Get More` วางเคียงคู่กันอย่างสวยงาม
- **เลือกสาขา Power Mall ประจำจุดขาย:** แสดงชื่อภาษาไทยเข้าใจง่าย (8 สาขา) พร้อมระบุชื่อ-นามสกุล และเบอร์โทรศัพท์ของ PC
- **Session Management & ความเป็นส่วนตัว:** แถบข้อมูล PC และปุ่ม **"ออก"** จะซ่อนอัตโนมัติในหน้า Landing และจะแสดงขึ้นเฉพาะเมื่อเข้าสู่ระบบประจำสาขาแล้วเท่านั้น

---

### 2. 🎁 โปรโมชั่นที่เปิดให้บริการ (Active Campaigns)

| แคมเปญ | รางวัล | สาขาที่ร่วมรายการ | เงื่อนไขสินค้า |
|---|---|---|---|
| **Campaign A (Haier x PTT)**<br>เย็นฉ่ำ แล้วยังเติมความสุขให้ทุกเส้นทาง | **บัตรเติมน้ำมัน PTT Privilege Card 500 บาท** | ทุกสาขา Power Mall (8 สาขา) | ซื้อแอร์ Haier Inverter 4 รุ่นยอดนิยม:<br>• `HSU-09VRRA055BF`<br>• `HSU-12VRRA05BF`<br>• `HSU-18VRRA05BF`<br>• `HSU-12VQEC05` |
| **Campaign B (Shop More Get More)**<br>Haier x Sports (LFC & PSG) | **Gift Voucher The Mall 1,000 บาท** | เฉพาะ 2 สาขา:<br>• **สยามพารากอน** (`S00449`)<br>• **เอ็มโพเรียม** (`S00327`) | ซื้อเครื่องใช้ไฟฟ้า Haier ทุกหมวด รวมยอดซื้อ **≥ 20,000 บาท** ขึ้นไป |

---

### 3. 📝 ฟอร์มลงทะเบียนอัจฉริยะ (Smart Registration Form)
- **3-Level Cascading Product Dropdowns:**
  1. **Category (หมวดหลัก 6 หมวด):** `AC` (แอร์), `RF` (ตู้เย็น), `WM` (เครื่องซักผ้า), `TV` (ทีวี), `FZ` (ตู้แช่), `WH` (เครื่องทำน้ำอุ่น)
  2. **SubCategory (หมวดย่อย):** เช่น Inverter, Fix Speed, Multi Door, SBS, OLED, Mini-LED, Front Load, Chest Freezer ฯลฯ
  3. **Model (รุ่นสินค้า SKU):** กรองรุ่นสินค้าตามหมวดหมู่ จากฐานข้อมูลสินค้า **415 SKU**
  - *สำหรับ Campaign A (AC):* ระบบจะ Auto-assign หมวด `AC` และ `Inverter` พร้อม Bypass การตรวจสอบให้อัตโนมัติ
- **Interactive Visual Calendar (ปฏิทินเลือกวันที่ซื้อ):** ปฏิทิน Flatpickr ภาษาไทย เลือกวันที่ซื้อสินค้าได้สะดวก
- **Dual Photo Uploads (แนบหลักฐานภาพถ่าย 2 รายการ):**
  - **ภาพที่ 1:** รูปถ่ายใบเสร็จรับเงิน (Receipt Photo)
  - **ภาพที่ 2:** รูปถ่ายบัตรกำนัลที่มอบให้ลูกค้า (Voucher Photo)
  - รองรับทั้งการถ่ายภาพจากกล้องมือถือและการเลือกไฟล์ภาพ
- **Voucher Confirmation Ticket (ป๊อปอัปยืนยันสิทธิ์ทันที):**
  - แสดงรหัสอ้างอิง **Voucher Ref Code** (เช่น `HR-20260822-7702`) พร้อม **QR Code**
  - แสดงสรุปข้อมูลลูกค้า สาขา รุ่นสินค้า และภาพตัวอย่าง 2 ภาพ
  - ทางเลือกด่วน 3 ปุ่ม: `ลงทะเบียนลูกค้ารายต่อไป (Next)`, `ดูรายการของสาขา`, หรือ `ออก (Exit)`

---

### 4. 🔒 การแยกสิทธิ์ข้อมูลแต่ละสาขา (Store Data Isolation for PC)
- เมนู **"รายการของสาขานี้" (Browse Submissions):** พนักงาน PC แต่ละสาขาจะ**เห็นเฉพาะรายการของสาขาตนเองเท่านั้น** ป้องกันไม่ให้สาขาอื่นเข้าถึงข้อมูลข้ามสาขา
- มีช่องค้นหาข้อมูลลูกค้า เบอร์โทรศัพท์ รหัส หรือวันที่ซื้อได้แบบ Real-time

---

### 5. 🛡️ ระบบผู้ดูแลระบบ (Admin Module & Audit Workflow)
- **รหัสผ่านเข้าใช้งาน:** `admin1234`
- **Dashboard สรุปภาพรวม:** ยอดลงทะเบียนรวมทุกสาขา, จำนวนที่อนุมัติแล้ว, จำนวนที่สั่งแก้ไข, มูลค่ารวมบัตรกำนัล (THB)
- **ระบบตรวจสอบและอนุมัติ (Audit Actions):**
  1. **อนุมัติ (Approve):** ยืนยันการมอบบัตรกำนัลถูกต้อง
  2. **ขอแก้ไข (Request Revision):** ระบุเหตุผลที่ต้องการให้ PC แก้ไข (เช่น ภาพใบเสร็จเบลอ, ยอดซื้อไม่ถึง) เพื่อให้ PC ประจำสาขากดปุ่ม **"แก้ไขข้อมูล"** ถ่ายรูปหรือแก้ข้อมูลส่งซ้ำได้
  3. **ปฏิเสธ (Reject):** ปฏิเสธสิทธิ์ที่ไม่ตรงตามเงื่อนไข
- **การลบข้อมูล (Deletion Controls):**
  - **ลบทีละรายการ (Single Delete):** กดปุ่มถังขยะสีแดงเพื่อลบรายการและไฟล์ภาพออกจากระบบทันที
  - **ลบข้อมูลทั้งหมด (Delete All Submissions):** ปุ่มล้างข้อมูลทั้งระบบ พร้อมระบบป้องกันความปลอดภัยโดยต้องพิมพ์คำว่า `CONFIRM-RESET`
- **📊 Rich Excel Export (`.xlsx`):**
  - ดึงรูปภาพจาก Cloudflare R2 / D1 มาฝังเป็น **ภาพ Thumbnail ขนาด 50x50px** ในเซลล์ Excel
  - สร้าง **URL ลิงก์รูปภาพ HTTPS แบบเต็ม** ที่สามารถคลิกเปิดดูรูปภาพต้นฉบับขนาดเต็มผ่านอินเทอร์เน็ตได้ทันที

---

## 🏗️ โครงสร้างสถาปัตยกรรมระบบ (System Architecture)

```
                       ┌─────────────────────────────────────────┐
                       │     PC / Admin Browser (Client)         │
                       │     - Tailwind CSS + Lucide Icons       │
                       │     - Flatpickr + QRCode.js + ExcelJS   │
                       └────────────────────┬────────────────────┘
                                            │ HTTP / JSON
                                            ▼
                       ┌─────────────────────────────────────────┐
                       │     Cloudflare Pages & Functions (API)  │
                       │  - POST /api/register                   │
                       │  - GET/PUT/DELETE /api/submissions      │
                       │  - GET /api/image/[[path]]              │
                       └────────────┬───────────────────┬────────┘
                                    │                   │
                        SQL Queries │                   │ Image Stream
                                    ▼                   ▼
                      ┌──────────────────┐    ┌──────────────────┐
                      │  Cloudflare D1   │    │  Cloudflare R2   │
                      │  (SQL Database)  │    │ (Object Storage) │
                      │   `voucher-db`   │    │ `voucher-photos` │
                      └──────────────────┘    └──────────────────┘
```

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)

```
Voucher Registration/
├── functions/                           # Cloudflare Serverless API Functions
│   └── api/
│       ├── register.js                  # POST /api/register (บันทึก D1 + อัปโหลด 2 รูปสู่ R2)
│       ├── submissions.js               # GET/PUT/DELETE /api/submissions (ดูรายการ/อนุมัติ/ลบ)
│       ├── dimensions.js                # GET /api/dimensions (ข้อมูลมิติสาขาและรุ่นสินค้า)
│       └── image/
│           └── [[path]].js              # GET /api/image/... (ดึงรูปจาก R2 พร้อม Fallback D1)
├── migrations/
│   └── 0001_init.sql                    # SQL Schema & ข้อมูลตั้งต้น (8 สาขา + 415 รุ่นสินค้า)
├── wrangler.toml                        # การตั้งค่า D1 Database ID และ R2 Bucket Binding
├── package.json                         # Node.js dependencies
├── index.html                           # เว็บแอปพลิเคชันหลัก (Single Page Application)
├── Voucher_Registration_PowerMall.md   # รายละเอียดสเปกระบบฉบับเต็ม
├── Dimension Store.csv / .json          # ข้อมูลมิติ 8 สาขา Power Mall
├── Dimension Model.csv / .json          # ข้อมูลมิติ 415 รุ่นสินค้า Haier
├── Ad AC PTT vc.png                     # ภาพโปสเตอร์โปรโมชั่น Campaign A
├── Ad PM vc.jpg                         # ภาพโปสเตอร์โปรโมชั่น Campaign B
├── .gitignore
└── README.md
```

---

## ⚙️ การตั้งค่าระบบ Cloudflare (Production Setup)

### 1. Cloudflare D1 Database
- **Database Name:** `voucher-db`
- **Database ID:** `dd94f98f-2ecd-4951-8fd3-7e75969793a6`
- **Binding Name:** `DB`

### 2. Cloudflare R2 Object Storage
- **Bucket Name:** `voucher-photos`
- **Binding Name:** `BUCKET`

### 3. การ Deploy ด้วย Wrangler CLI
```bash
# ติดตั้ง dependencies
npm install

# รัน Migration ฐานข้อมูล D1
npx wrangler d1 execute voucher-db --remote --file=./migrations/0001_init.sql

# Deploy เว็บขึ้น Cloudflare Pages
npx wrangler pages deploy . --project-name=voucher-registration-powermall
```

---

## 📄 ลิขสิทธิ์และการดูแลระบบ (License & Support)
© 2026 **Haier Electrical Appliances (Thailand) Co., Ltd.** & **Power Mall (The Mall Group)**.  
ระบบพัฒนาด้วย Cloudflare Pages, Cloudflare D1 Database, Cloudflare R2 Storage และ Tailwind CSS
