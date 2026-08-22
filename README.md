# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)

ระบบเว็บแอปพลิเคชัน Full-Stack สำหรับ **พนักงานขาย (PC/Promoter) ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบสิทธิ์โปรโมชั่นแบบ Real-time แนบภาพหลักฐาน 2 รายการ และบันทึกข้อมูลเข้าสู่ฐานข้อมูลกลาง **Cloudflare D1** พร้อมจัดเก็บรูปภาพใน **Cloudflare R2**

---

## 🌟 ฟังก์ชันหลัก (Core Features)

1. **PC & Store Check-In Landing Page:**
   - หน้าแรกเริ่มต้นด้วยการเลือก **สาขา Power Mall ประจำจุดขาย (8 สาขา)** พร้อมระบุ **ชื่อ-นามสกุล และเบอร์โทรศัพท์ของ PC**
   - ในฟอร์มลงทะเบียนลูกค้าจึงไม่ต้องกรอกชื่อ/เบอร์ PC ซ้ำอีก
2. **Next / End Workflow:**
   - หน้ายืนยันสิทธิ์มีปุ่ม **"ลงทะเบียนลูกค้ารายต่อไป (Next)"** เพื่อรับลูกค้าใหม่อย่างรวดเร็ว
   - หรือปุ่ม **"จบการทำงาน (End)"** เพื่อออกจากระบบและสลับกะ/สาขา
3. **3-Level Cascading Product Selector (เลือกสินค้า 3 ระดับ):**
   - **Category (หมวดหลัก 6 หมวด):** `AC`, `RF`, `WM`, `TV`, `FZ`, `WH`
   - **SubCategory (หมวดย่อย):** เช่น Inverter, Multi Door, OLED, QLED, Chest, Digital
   - **Model (รุ่นสินค้า):** กรองรุ่นสินค้า (SKU) ตาม Category + SubCategory จากฐานข้อมูล **Dimension Model ทั้งหมด 415 รุ่น**
4. **Interactive Visual Calendar Picker (ปฏิทินเลือกวันที่ซื้อ):**
   - ปฏิทิน Pop-up ภาษาไทย รองรับการกดสัมผัสบนจอ POS/แท็บเล็ต/คอมพิวเตอร์
5. **Dual Photo Uploads (แนบหลักฐานภาพถ่าย 2 รายการ):**
   - **ภาพที่ 1:** รูปถ่ายใบเสร็จรับเงิน (Receipt Photo)
   - **ภาพที่ 2:** รูปถ่ายบัตรกำนัลที่มอบให้ลูกค้า (Voucher Photo)
   - อัปโหลดตรงเข้าสู่ **Cloudflare R2 Object Storage**
6. **Admin Module Protected by Password (`admin1234`):**
   - ระบบป้องกันความปลอดภัยหน้า Admin ด้วยการยืนยันรหัสผ่าน
7. **Rich Excel Export (`.xlsx` พร้อมภาพ Thumbnail และ Hyperlink):**
   - ส่งออกไฟล์ Excel แท้ ฝังรูปภาพ Thumbnail ขนาดพอเหมาะในเซลล์
   - มีคอลัมน์ลิงก์กดเปิดดูรูปภาพต้นฉบับบนเซิร์ฟเวอร์ได้ทันที

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
├── wrangler.toml                        # การตั้งค่า Cloudflare Pages
├── package.json                         # Dependencies & Scripts
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

## 📄 ลิขสิทธิ์ (License)
© 2026 Haier Electrical Appliances (Thailand) Co., Ltd. & Power Mall (The Mall Group). Powered by Cloudflare Pages, D1 & R2.
