# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)
**Document Version:** 2.5.0 (Updated: Admin Password Protection, Excel Export with Thumbnails, PC Check-In Landing, and End-Shift Flow)  
**Target Platform:** Cloudflare Pages + Workers + D1 Database + R2 Object Storage  
**Brand Design System:** Haier Electric Thailand & Power Mall (The Mall Group)

---

## 1. ภาพรวมระบบและข้อกำหนดหลัก (Executive Overview)

ระบบ **Voucher Registration for Power Mall** เป็นเว็บแอปพลิเคชันสำหรับ **พนักงานขาย (PC/Promoter) ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบสิทธิ์โปรโมชั่นแบบ Real-time แนบหลักฐานภาพถ่าย 2 รายการ และบันทึกข้อมูลเข้าสู่ระบบกลาง Cloudflare D1 & R2

### สรุปฟังก์ชันสำคัญ 4 ข้อล่าสุด (Latest Key Features)
1. **ระบบความปลอดภัย Admin ด้วยรหัสผ่าน (Password: `admin1234`):**
   - การเข้าสู่หน้า Admin Management ต้องผ่านการยืนยันรหัสผ่าน `admin1234`
2. **ระบบส่งออกไฟล์ Excel (`.xlsx`) พร้อมรูปภาพ Thumbnail และลิงก์รูปจริง:**
   - ส่งออกข้อมูลเป็นไฟล์ Excel แท้ (`.xlsx` ผ่าน ExcelJS)
   - ฝังรูปภาพขนาด Thumbnail ของ **ใบเสร็จรับเงิน** และ **บัตรกำนัล** ในช่องตาราง Excel โดยตรง
   - มีคอลัมน์ลิงก์ Hyperlink `🔗 เปิดดูรูปบนเซิร์ฟเวอร์` เพื่อคลิกเปิดดูรูปความละเอียดสูงบนเซิร์ฟเวอร์ได้ทันที
3. **หน้าแรกเริ่มต้นด้วยการ Check-in สาขาและข้อมูลพนักงาน (PC Check-in Landing Screen):**
   - พนักงานต้องเลือก **สาขาประจำจุดบริการ (8 สาขา)** และกรอก **ชื่อ-นามสกุล PC** พร้อม **เบอร์โทรศัพท์ PC** ตั้งแต่หน้าแรก
   - ในฟอร์มลงทะเบียนลูกค้าจึง **ตัดช่องกรอกชื่อ/เบอร์ PC ออก** เพื่อความรวดเร็วในการบริการหน้าร้าน
4. **ปุ่ม "ลงทะเบียนลูกค้ารายต่อไป (Next)" หรือ "จบการทำงาน (End)":**
   - เมื่อลงทะเบียนเสร็จ พนักงานสามารถกด `ลงทะเบียนลูกค้ารายต่อไป` เพื่อเปิดรับลูกค้ารายใหม่ได้ทันทีโดยไม่ต้องกรอกข้อมูล PC ซ้ำ
   - หรือกด `จบการทำงาน (End)` เพื่อเคลียร์กะและเปลี่ยนสาขา/พนักงาน

---

## 2. แคมเปญที่เปิดใช้งานและภาพโปรโมชั่น (Active Campaigns & Visual Assets)

### 📌 Campaign A: "เย็นฉ่ำ แล้วยังเติมความสุขให้ทุกเส้นทาง" (Haier x PTT)
![Campaign A - Haier x PTT](/Users/anotai/.gemini/antigravity/brain/487b3516-dfb7-454f-8c98-63fa02b32342/ad_ac_ptt.png)

| หัวข้อ | รายละเอียด |
| :--- | :--- |
| **รหัสแคมเปญ** | `CAMP-2026-PTT-AC` |
| **ระยะเวลาโปรโมชั่น** | วันนี้ – 31 สิงหาคม 2569 |
| **ของรางวัล** | **บัตรเติมน้ำมัน PTT Privilege Card มูลค่า 500 บาท** (Flat Reward) |
| **เงื่อนไขสินค้า** | ซื้อเครื่องปรับอากาศ Haier เฉพาะ **4 รุ่นที่ร่วมรายการ** (Category: `AC` / SubCategory: `Inverter`):<br>1. `HSU-09VRRA055BF` (UV Cool Smart 9,200 BTU)<br>2. `HSU-12VRRA05BF` (UV Cool Smart 12,300 BTU)<br>3. `HSU-18VRRA05BF` (UV Cool Smart 18,000 BTU)<br>4. `HSU-12VQEC05` (Clean Cool 12,000 BTU) |
| **สาขาที่ร่วมรายการ** | **ทุกสาขา Power Mall ที่เปิดให้บริการ (All Active Stores)** |
| **หลักฐานที่ต้องแนบ (2 ภาพ)** | 1. รูปถ่ายใบเสร็จรับเงิน<br>2. รูปถ่ายบัตรเติมน้ำมัน PTT 500 บาทที่ส่งมอบให้ลูกค้า |

---

### 📌 Campaign B: "Shop More Get More" (Haier x LFC x PSG)
![Campaign B - Shop More Get More](/Users/anotai/.gemini/antigravity/brain/487b3516-dfb7-454f-8c98-63fa02b32342/ad_pm_vc.jpg)

| หัวข้อ | รายละเอียด |
| :--- | :--- |
| **รหัสแคมเปญ** | `CAMP-2026-SPORTS-MALL` |
| **ระยะเวลาโปรโมชั่น** | 22 สิงหาคม 2569 – 30 กันยายน 2569 |
| **ของรางวัล** | **Gift Voucher The Mall มูลค่า 1,000 บาท** (เมื่อซื้อครบ 20,000 บาทขึ้นไป) |
| **เงื่อนไขสินค้า** | ซื้อเครื่องใช้ไฟฟ้า Haier **ทุกหมวดหมู่/ทุกประเภทย่อย/ทุกรุ่น (All 415 Models)** ยอดสุทธิในใบเสร็จรวม **≥ 20,000 บาท** |
| **สาขาที่ร่วมรายการ** | **เฉพาะ 2 สาขาเท่านั้น:**<br>1. `PM:SIAM_PARAGON` (Store ID: `S00449`) - สยามพารากอน<br>2. `PM:EMPORIUM` (Store ID: `S00327`) - เอ็มโพเรียม<br>*(ระบบทำการ Lock และ Grey-out แคมเปญนี้โดยอัตโนมัติหากเลือกสาขาอื่น)* |
| **หลักฐานที่ต้องแนบ (2 ภาพ)** | 1. รูปถ่ายใบเสร็จรับเงินยอดรวมตั้งแต่ 20,000 บาทขึ้นไป<br>2. รูปถ่ายบัตร The Mall Gift Voucher 1,000 บาทที่ส่งมอบให้ลูกค้า |

---

## 3. ข้อมูลมิติสาขาและโครงสร้างสินค้า (Dimension Data)

### 3.1 ข้อมูลมิติสาขา (Dimension Store)

| STORE_ID | STORE_NAME | Store Name TH | Province TH | Region TH | Active Status | Campaign B Eligible |
| :--- | :--- | :--- | :--- | :--- | :---: | :---: |
| `S00449` | `PM:SIAM_PARAGON` | สยามพารากอน | กรุงเทพมหานคร | กรุงเทพฯและภาคกลาง | **Active** | ✅ ใช่ |
| `S00327` | `PM:EMPORIUM` | เอ็มโพเรียม | กรุงเทพมหานคร | กรุงเทพฯและภาคกลาง | **Active** | ✅ ใช่ |
| `S00222` | `PM-NAKHONRATCHASIMA` | เดอะมอลล์ โคราช | นครราชสีมา | ภาคตะวันออกเฉียงเหนือ | **Active** | ❌ ไม่ใช่ |
| `S00349` | `PM:NGAMWONGWAN` | เดอะมอลล์ งามวงศ์วาน | นนทบุรี | กรุงเทพฯและภาคกลาง | **Active** | ❌ ไม่ใช่ |
| `S00370` | `PM:THAPRA` | เดอะมอลล์ ท่าพระ | กรุงเทพมหานคร | กรุงเทพฯและภาคกลาง | **Active** | ❌ ไม่ใช่ |
| `S00190` | `PM:BANGKAE` | เดอะมอลล์ บางแค | กรุงเทพมหานคร | กรุงเทพฯและภาคกลาง | **Active** | ❌ ไม่ใช่ |
| `S00066` | `PM:BANGKAPI` | เดอะมอลล์ บางกะปิ | กรุงเทพมหานคร | กรุงเทพฯและภาคกลาง | **Active** | ❌ ไม่ใช่ |
| `S00795` | `PM:RAMKAMHANG` | เดอะมอลล์ รามคำแหง | กรุงเทพมหานคร | กรุงเทพฯและภาคกลาง | **Not active** | ❌ ไม่ใช่ |

---

### 3.2 โครงสร้าง Category & SubCategory (415 SKUs)

| หมวดหมู่หลัก (Category) | หมวดหมู่ย่อย (SubCategory) | รายละเอียด / ตัวอย่างสินค้า | จำนวนรุ่น |
| :--- | :--- | :--- | :---: |
| **AC (เครื่องปรับอากาศ)** | Inverter | แอร์ระบบอินเวอร์เตอร์ ประหยัดไฟเบอร์ 5 (รวม 4 รุ่นแคมเปญ A) | 71 รุ่น |
| | Fix Speed | แอร์ระบบธรรมดา ทำความเย็นคงที่ | 18 รุ่น |
| | Floor Standing | แอร์แบบตู้ตั้งพื้นขนาดใหญ่ | 1 รุ่น |
| **RF (ตู้เย็น)** | Multi Dr | ตู้เย็นมัลติดอร์ 4 ประตูขึ้นไป | 16 รุ่น |
| | SBS | ตู้เย็น Side-by-Side 2 ประตูแนวตั้ง | 6 รุ่น |
| | 2Dr | ตู้เย็น 2 ประตู ช่องฟรีซบน | 30 รุ่น |
| | 1Dr | ตู้เย็น 1 ประตู ขนาดกะทัดรัด | 16 รุ่น |
| | BM | ตู้เย็น Bottom Mount ช่องฟรีซล่าง | 2 รุ่น |
| **WM (เครื่องซักผ้า/อบผ้า)** | FL Wash&Dry | เครื่องซักผ้าฝาหน้าพร้อมฟังก์ชันอบผ้า | 11 รุ่น |
| | Front Load | เครื่องซักผ้าฝาหน้า | 19 รุ่น |
| | Top Load | เครื่องซักผ้าฝาบนอัตโนมัติ | 27 รุ่น |
| | Twin Tub | เครื่องซักผ้า 2 ถังกึ่งอัตโนมัติ | 14 รุ่น |
| | Dryer | เครื่องอบผ้าฝาหน้า | 6 รุ่น |
| **TV (โทรทัศน์)** | OLED | พรีเมียม OLED TV 4K 120Hz | 1 รุ่น |
| | MINI-LED | Mini-LED 4K Google TV | 5 รุ่น |
| | QLED | QLED 4K Google TV สมาร์ททีวี | 25 รุ่น |
| | UHD | 4K UHD Smart TV | 21 รุ่น |
| | FHD | Full HD / Android TV | 22 รุ่น |
| **FZ (ตู้แช่แข็ง/ไวน์)** | Beverage | ตู้แช่เครื่องดื่ม 1-3 ประตู | 17 รุ่น |
| | Chest | ตู้แช่แข็งฝาทึบระบบ Dual Freeze | 35 รุ่น |
| | Vertical | ตู้แช่แข็งแนวตั้งแบบชั้น | 4 รุ่น |
| | Wine | ตู้แช่ไวน์ระบบคอมเพรสเซอร์เงียบ | 7 รุ่น |
| | Glass | ตู้แช่ฝากระจกโค้ง/กระจกใส | 6 รุ่น |
| **WH (เครื่องทำน้ำอุ่น/ตู้น้ำ)** | Digital | เครื่องทำน้ำอุ่นระบบดิจิทัล หน้าจอดิจิทัล | 13 รุ่น |
| | Manual | เครื่องทำน้ำอุ่นระบบลูกบิดแมนนวล | 20 รุ่น |
| | Water Dispenser | ตู้น้ำดื่มร้อน-เย็น ถังน้ำด้านล่าง | 2 รุ่น |
| **รวมทั้งหมด** | | | **415 รุ่น** |

---

## 4. แผนผังการทำงานของผู้ใช้งาน (Updated User Journey)

```mermaid
flowchart TD
    Start([1. เปิดเว็บแอปพลิเคชัน]) --> CheckIn[2. หน้า Landing: เลือกสาขา + กรอกชื่อ & เบอร์โทร PC]
    CheckIn --> StoreMenu[3. เข้าสู่หน้าหลักประจำสาขา]
    
    StoreMenu -->|ลงทะเบียนลูกค้า| Form[4. เลือกแคมเปญ → เลือก Category → SubCategory → Model → ปฏิทินวันที่ซื้อ]
    StoreMenu -->|ดูประวัติสาขา| Logs[5. รายการลงทะเบียนประจำสาขา]
    StoreMenu -->|เข้า Admin| AdminPwd[6. ยืนยันรหัสผ่าน Admin: admin1234]
    
    AdminPwd --> AdminDash[7. Admin Dashboard: ดูภาพจริง / Export Excel พร้อมรูปและลิงก์]
    
    Form --> PhotoAttach[8. แนบรูปถ่าย 2 ภาพ: 1.ใบเสร็จ + 2.บัตรกำนัล]
    PhotoAttach --> Confirm[9. หน้ายืนยันสิทธิ์ พร้อมออกรหัส Voucher & QR Code]
    
    Confirm -->|Next| NextCust[ลงทะเบียนลูกค้ารายต่อไป (คงสาขาและ PC เดิม)]
    Confirm -->|End| EndShift[จบการทำงาน / ออกจากระบบกลับสู่หน้า Landing]
```

---

## 5. เอกสารแนบและไฟล์อ้างอิงในระบบ (Attached Reference Files)
- **เว็บแอปพลิเคชันพร้อมใช้งาน:** `index.html` (พร้อม Admin Password, Excel Export, PC Check-In, Next/End actions)
- **รูปภาพโปสเตอร์ Campaign A (Haier x PTT):** `Ad AC PTT vc.png`
- **รูปภาพโปสเตอร์ Campaign B (Shop More Get More):** `Ad PM vc.jpg`
- **ไฟล์ข้อมูลสาขา (Dimension Store):** `Dimension Store.csv` / `Dimension Store.json`
- **ไฟล์ข้อมูลรุ่นสินค้า (Dimension Model):** `Dimension Model.csv` / `Dimension Model.json`
