# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)

ระบบเว็บแอปพลิเคชัน Full-Stack สำหรับ **พนักงานขาย (PC/Promoter) ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบสิทธิ์โปรโมชั่นแบบ Real-time แนบภาพหลักฐาน 2 รายการ และบันทึกข้อมูลเข้าสู่ฐานข้อมูลกลาง **Cloudflare D1** พร้อมจัดเก็บรูปภาพใน **Cloudflare R2**

---

## 🌟 ฟังก์ชันหลัก (Core Features)

1. **Landing Page with Campaign Posters & PC Check-In:**
   - หน้าแรกแสดง **ภาพโปสเตอร์โปรโมชั่น 2 แคมเปญ (Haier x PTT & Shop More Get More)** เด่นชัด
   - เลือก **สาขา Power Mall ประจำจุดขาย (8 สาขา)** พร้อมระบุ **ชื่อ-นามสกุล และเบอร์โทรศัพท์ของ PC** เพื่อเริ่มต้นให้บริการ
2. **Admin Audit & PC Revision Workflow (ระบบตรวจสอบและส่งแก้ไข):**
   - **Admin:** ตรวจสอบรูปภาพใบเสร็จ/บัตรกำนัล และสามารถกด **"อนุมัติ"**, **"ขอให้แก้ไขข้อมูล (ระบุเหตุผล)"**, หรือ **"ปฏิเสธ"**
   - **PC:** สามารถดูหน้ารายการของสาขา หากรายการใดต้องแก้ไข จะมีปุ่ม **"แก้ไขข้อมูล"** เพื่อเปิดฟอร์มเดิมพร้อมข้อความเตือนจาก Admin ให้ถ่ายรูปใหม่หรือแก้ข้อมูลแล้วส่งซ้ำ
3. **ปุ่มออกจากระบบเปลี่ยนเป็น "ออก":**
   - แสดงปุ่ม **"ออก"** ที่มุมบนของหน้าเว็บ และในหน้าออกรหัสบัตรกำนัล
4. **Rich Excel Export (`.xlsx` พร้อมภาพ Thumbnail และ Hyperlink):**
   - ส่งออกไฟล์ Excel แท้ ฝังรูปภาพ Thumbnail ขนาดพอเหมาะในเซลล์ และมีลิงก์กดเปิดดูรูปภาพต้นฉบับบนเซิร์ฟเวอร์
5. **3-Level Cascading Product Selector (เลือกสินค้า 3 ระดับ):**
   - **Category (หมวดหลัก 6 หมวด):** `AC`, `RF`, `WM`, `TV`, `FZ`, `WH`
   - **SubCategory (หมวดย่อย):** เช่น Inverter, Multi Door, OLED, QLED, Chest, Digital
   - **Model (รุ่นสินค้า):** กรองรุ่นสินค้า (SKU) ตาม Category + SubCategory จากฐานข้อมูล **Dimension Model ทั้งหมด 415 รุ่น**
6. **Dual Photo Uploads (แนบหลักฐานภาพถ่าย 2 รายการ):**
   - **ภาพที่ 1:** รูปถ่ายใบเสร็จรับเงิน (Receipt Photo)
   - **ภาพที่ 2:** รูปถ่ายบัตรกำนัลที่มอบให้ลูกค้า (Voucher Photo)
   - อัปโหลดตรงเข้าสู่ **Cloudflare R2 Object Storage**
7. **Admin Module Protected by Password (`admin1234`):**
   - ระบบป้องกันความปลอดภัยหน้า Admin ด้วยการยืนยันรหัสผ่าน

---

## 📁 โครงสร้างโปรเจกต์ (Full-Stack Project Structure)

```
Voucher Registration/
├── functions/                           # Cloudflare Pages Serverless Functions (API)
│   └── api/
│       ├── register.js                  # POST /api/register (บันทึก/แก้ไข D1 + อัปโหลดรูปภาพ 2 รูปสู่ R2)
│       ├── submissions.js               # GET & PUT /api/submissions (ดึงรายการ & อัปเดตสถานะ/ขอแก้ไข)
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
