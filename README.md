# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)

เว็บแอปพลิเคชันสำหรับ **พนักงานขาย (PC/Promoter) ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบสิทธิ์ตามเงื่อนไขโปรโมชั่นแบบ Real-time และออกรหัสรับบัตรกำนัล (Voucher Reference Code / QR Code) ให้แก่ลูกค้า

---

## 🌟 ฟังก์ชันหลัก (Core Features)

1. **3-Level Cascading Product Selector (เลือกสินค้า 3 ระดับ):**
   - **Category (หมวดหมู่หลัก):** `AC` (เครื่องปรับอากาศ), `RF` (ตู้เย็น), `WM` (เครื่องซักผ้า/อบผ้า), `TV` (โทรทัศน์), `FZ` (ตู้แช่แข็ง/ไวน์), `WH` (เครื่องทำน้ำอุ่น/ตู้น้ำดื่ม)
   - **SubCategory (หมวดหมู่ย่อย):** กรองตามหมวดหลัก เช่น Inverter, Multi Door, OLED, QLED, Chest, Digital
   - **Model (รุ่นสินค้า):** กรองรายชื่อรุ่นสินค้า (SKU) ตาม Category + SubCategory จากฐานข้อมูล **Dimension Model ทั้งหมด 415 รุ่น**
2. **Interactive Visual Calendar Picker (ปฏิทินเลือกวันที่ซื้อ):**
   - ปฏิทิน Pop-up ภาษาไทย รองรับการกดสัมผัสบนจอ POS/แท็บเล็ต/คอมพิวเตอร์
3. **Dual Photo Uploads (แนบหลักฐานภาพถ่าย 2 รายการ):**
   - **ภาพที่ 1:** รูปถ่ายใบเสร็จรับเงิน (Receipt Photo)
   - **ภาพที่ 2:** รูปถ่ายบัตรกำนัลที่มอบให้ลูกค้า (Voucher Photo)
4. **Dynamic Campaign & Store Eligibility Gating:**
   - **Campaign A (Haier x PTT):** บัตรเติมน้ำมัน PTT 500 บาท เมื่อซื้อแอร์ 4 รุ่นที่กำหนด (เปิดทุกสาขา)
   - **Campaign B (Shop More Get More):** The Mall Gift Voucher 1,000 บาท เมื่อซื้อครบ 20,000 บาทขึ้นไป (จำกัดเฉพาะสาขา **สยามพารากอน `S00449`** และ **เอ็มโพเรียม `S00327`**)
5. **Instant Voucher Reference & QR Code:**
   - ออกรหัส Voucher ทันที พร้อม QR Code และปุ่มสั่งพิมพ์ใบรับสิทธิ์
6. **Store Historical Submissions & Admin Panel:**
   - หน้าค้นหาประวัติการลงทะเบียนย้อนหลังประจำสาขา
   - หน้า Admin ตรวจสอบรูปภาพใบเสร็จ/บัตรกำนัล และส่งออกข้อมูลเป็นไฟล์ CSV

---

## 📁 โครงสร้างโปรเจกต์ (Project Structure)

```
Voucher Registration/
├── index.html                           # เว็บแอปพลิเคชันหลัก (Single Page Application)
├── Voucher_Registration_PowerMall.md   # เอกสารสเปกระบบฉบับสมบูรณ์ & Cloudflare D1 SQL Schema
├── Dimension Store.csv                  # ข้อมูลมิติสาขา Power Mall (8 สาขา)
├── Dimension Store.json                 # ข้อมูลมิติสาขาในรูปแบบ JSON
├── Dimension Model.csv                  # ข้อมูลมิติสินค้า Haier (415 SKUs)
├── Dimension Model.json                 # ข้อมูลมิติสินค้าในรูปแบบ JSON
├── Ad AC PTT vc.png                     # โปสเตอร์โปรโมชั่น Campaign A (Haier x PTT)
├── Ad PM vc.jpg                         # โปสเตอร์โปรโมชั่น Campaign B (Shop More Get More)
├── .gitignore                           # Git ignore rules
└── README.md                            # เอกสารแนะนำโปรเจกต์
```

---

## 🚀 วิธีการติดตั้งและรันใช้งาน (Getting Started)

### 1. ทดสอบใช้งานบนเครื่อง Local
ดับเบิลคลิกเปิดไฟล์ `index.html` บนเว็บเบราว์เซอร์ (Chrome, Edge, Safari) หรือรัน Local Server:
```bash
npx serve .
```

### 2. Deploy ขึ้น Cloudflare Pages
1. นำ Repository นี้เชื่อมต่อกับ **Cloudflare Pages** ผ่าน GitHub
2. Build Settings:
   - **Framework preset:** `None`
   - **Build command:** *(เว้นว่าง)*
   - **Build output directory:** `.`
3. กด **Save and Deploy** เพื่อเปิดใช้งานบนโดเมนของ Cloudflare Pages ทันที

---

## 📄 ลิขสิทธิ์ (License)
© 2026 Haier Electrical Appliances (Thailand) Co., Ltd. & Power Mall (The Mall Group). All rights reserved.
