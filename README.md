# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)

ระบบเว็บแอปพลิเคชัน Full-Stack สำหรับ **พนักงานขาย (PC/Promoter) ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบสิทธิ์โปรโมชั่นแบบ Real-time แนบภาพหลักฐาน 2 รายการ และบันทึกข้อมูลเข้าสู่ฐานข้อมูลกลาง **Cloudflare D1** พร้อมจัดเก็บรูปภาพใน **Cloudflare R2**

---

## 🌟 ฟังก์ชันหลัก (Core Features)

1. **3-Level Cascading Product Selector (เลือกสินค้า 3 ระดับ):**
   - **Category (หมวดหลัก 6 หมวด):** `AC`, `RF`, `WM`, `TV`, `FZ`, `WH`
   - **SubCategory (หมวดย่อย):** เช่น Inverter, Multi Door, OLED, QLED, Chest, Digital
   - **Model (รุ่นสินค้า):** กรองรุ่นสินค้า (SKU) ตาม Category + SubCategory จากฐานข้อมูล **Dimension Model ทั้งหมด 415 รุ่น**
2. **Interactive Visual Calendar Picker (ปฏิทินเลือกวันที่ซื้อ):**
   - ปฏิทิน Pop-up ภาษาไทย รองรับการกดสัมผัสบนจอ POS/แท็บเล็ต/คอมพิวเตอร์
3. **Dual Photo Uploads (แนบหลักฐานภาพถ่าย 2 รายการ):**
   - **ภาพที่ 1:** รูปถ่ายใบเสร็จรับเงิน (Receipt Photo)
   - **ภาพที่ 2:** รูปถ่ายบัตรกำนัลที่มอบให้ลูกค้า (Voucher Photo)
   - อัปโหลดตรงเข้าสู่ **Cloudflare R2 Object Storage**
4. **Cloudflare D1 Centralized Database:**
   - รวมศูนย์ข้อมูลการลงทะเบียนจากทุกสาขา (พารากอน, เอ็มโพเรียม, โคราช ฯลฯ) เข้าสู่ฐานข้อมูล SQL เดียวกัน
5. **Dynamic Campaign & Store Eligibility Gating:**
   - **Campaign A (Haier x PTT):** บัตรเติมน้ำมัน PTT 500 บาท เมื่อซื้อแอร์ 4 รุ่นที่กำหนด (เปิดทุกสาขา)
   - **Campaign B (Shop More Get More):** The Mall Gift Voucher 1,000 บาท เมื่อซื้อครบ 20,000 บาทขึ้นไป (จำกัดเฉพาะสาขา **สยามพารากอน `S00449`** และ **เอ็มโพเรียม `S00327`**)
6. **Store Historical Submissions & Admin Panel:**
   - หน้าค้นหาประวัติการลงทะเบียนย้อนหลังประจำสาขาแบบ Real-time
   - หน้า Admin ตรวจสอบรูปภาพใบเสร็จ/บัตรกำนัล และส่งออกข้อมูลเป็นไฟล์ CSV

---

## 📁 โครงสร้างโปรเจกต์ (Full-Stack Project Structure)

```
Voucher Registration/
├── functions/                           # Cloudflare Pages Serverless Functions (API)
│   └── api/
│       ├── register.js                  # POST /api/register (บันทึก D1 + อัปโหลดรูปภาพ 2 รูปสู่ R2)
│       ├── submissions.js               # GET /api/submissions (ดึงรายการย้อนหลังตามสาขา / Admin)
│       ├── dimensions.js                # GET /api/dimensions (ดึงข้อมูลมิติสาขาและรุ่นสินค้า)
│       └── image/
│           └── [[path]].js              # GET /api/image/... (ดึงรูปภาพจาก R2 มาแสดงผล)
├── migrations/
│   └── 0001_init.sql                    # SQL Schema & Seed Data (8 สาขา + 415 รุ่นสินค้า)
├── wrangler.toml                        # การตั้งค่า Bindings ของ D1 (DB) และ R2 (BUCKET)
├── package.json                         # Scripts คำสั่งจัดการ Cloudflare D1 / R2
├── index.html                           # เว็บแอปพลิเคชัน Kiosk UI (Single Page Application)
├── Voucher_Registration_PowerMall.md   # เอกสารสเปกระบบฉบับสมบูรณ์
├── Dimension Store.csv / .json          # ข้อมูลมิติสาขา Power Mall
├── Dimension Model.csv / .json          # ข้อมูลมิติสินค้า Haier
├── Ad AC PTT vc.png                     # โปสเตอร์โปรโมชั่น Campaign A
├── Ad PM vc.jpg                         # โปสเตอร์โปรโมชั่น Campaign B
├── .gitignore
└── README.md
```

---

## 🚀 วิธีการ Setup Cloudflare D1 & R2 และ Deploy (Step-by-Step)

### ขั้นตอนที่ 1: Push โค้ดล่าสุดขึ้น GitHub
```bash
git push -u origin main
```

---

### ขั้นตอนที่ 2: สร้าง D1 Database & R2 Bucket บน Cloudflare

คุณสามารถสร้างผ่าน **Cloudflare Dashboard** หรือผ่าน **Terminal / Wrangler** ดังนี้ครับ:

#### ตัวเลือก ก) ทำผ่าน Cloudflare Dashboard (ผ่านเว็บเบราว์เซอร์):
1. **สร้าง D1 Database:**
   - ไปที่ **Cloudflare Dashboard** → **Storage & Databases** → **D1 SQL Database**
   - กด **Create database** → ตั้งชื่อ `haier-voucher-db`
   - ในหน้า Console ของ Database ให้นำคำสั่ง SQL ในไฟล์ `migrations/0001_init.sql` ไปวางแล้วกด **Execute**
2. **สร้าง R2 Bucket:**
   - ไปที่ **Storage & Databases** → **R2 Object Storage**
   - กด **Create bucket** → ตั้งชื่อ `haier-voucher-photos`

#### ตัวเลือก ข) ทำผ่าน Terminal / Command Line:
```bash
# 1. สร้าง D1 Database
npx wrangler d1 create haier-voucher-db

# 2. นำเข้าโครงสร้างตารางและข้อมูลตั้งต้น (8 สาขา + 415 รุ่นสินค้า)
npx wrangler d1 execute haier-voucher-db --remote --file=./migrations/0001_init.sql

# 3. สร้าง R2 Bucket สำหรับเก็บรูปถ่าย
npx wrangler r2 bucket create haier-voucher-photos
```

---

### ขั้นตอนที่ 3: ผูก D1 & R2 เข้ากับ Cloudflare Pages Project

1. ไปที่ **Cloudflare Dashboard** → **Workers & Pages** → เลือกโปรเจกต์ Pages ของคุณ
2. ไปที่แท็บ **Settings** → **Functions**
3. เลื่อนลงมาที่หัวข้อ **D1 database bindings**:
   - กด **Add binding**
   - Variable name: `DB`
   - D1 database: เลือก `haier-voucher-db`
4. เลื่อนลงมาที่หัวข้อ **R2 bucket bindings**:
   - กด **Add binding**
   - Variable name: `BUCKET`
   - R2 bucket: เลือก `haier-voucher-photos`
5. กด **Save** แล้วทำการ Deploy ใหม่อีกครั้ง (Redeploy)

---

## 📄 ลิขสิทธิ์ (License)
© 2026 Haier Electrical Appliances (Thailand) Co., Ltd. & Power Mall (The Mall Group). Powered by Cloudflare Pages, D1 & R2.
