# ระบบลงทะเบียนรับบัตรกำนัล Power Mall x Haier (Voucher Registration for Power Mall)
**Document Version:** 2.6.0 (Updated: Landing Page with 2 Ad Posters, Exit Button as 'ออก', and Admin Audit & PC Revision Workflow)  
**Target Platform:** Cloudflare Pages + Workers + D1 Database + R2 Object Storage  
**Brand Design System:** Haier Electric Thailand & Power Mall (The Mall Group)

---

## 1. ภาพรวมระบบและข้อกำหนดหลัก (Executive Overview)

ระบบ **Voucher Registration for Power Mall** เป็นเว็บแอปพลิเคชัน Full-Stack สำหรับ **พนักงานขาย (PC/Promoter) ณ ห้างสรรพสินค้า Power Mall (เครือ The Mall Group)** เพื่อลงทะเบียนการซื้อสินค้าแบรนด์ Haier ของลูกค้า ตรวจสอบสิทธิ์โปรโมชั่นแบบ Real-time แนบหลักฐานภาพถ่าย 2 รายการ และบันทึกข้อมูลเข้าสู่ฐานข้อมูลกลาง Cloudflare D1 & R2 พร้อมระบบตรวจสอบสิทธิ์และขอแก้ไขข้อมูลโดย Admin

### สรุปฟังก์ชันสำคัญล่าสุด (Core Features & Workflows)
1. **หน้าแรกเริ่มต้น (Landing Page) พร้อมภาพโปสเตอร์ 2 แคมเปญ:**
   - เริ่มต้นที่หน้า Landing เสมอ (ไม่ใช้ Session เดิมค้างไว้)
   - แสดงภาพโปสเตอร์โปรโมชั่น 2 แคมเปญ (Haier x PTT & Shop More Get More) ชัดเจนตั้งแต่หน้าแรก
   - กล่อง Check-in: เลือกสาขาประจำจุดบริการ (8 สาขา) และระบุชื่อ/เบอร์โทร PC
2. **ปุ่มออกจากระบบเปลี่ยนเป็น "ออก":**
   - ปุ่มบนแถบ Header ด้านบน และในหน้าจอยืนยันสิทธิ์ แสดงชื่อปุ่มชัดเจนว่า **"ออก"**
3. **ระบบ Admin ตรวจสอบและขอให้ส่งข้อมูลแก้ไขใหม่ (Admin Audit & PC Revision Workflow):**
   - **Admin:** ตรวจสอบรูปภาพใบเสร็จ/บัตรกำนัล และเลือกดำเนินการได้ 3 แบบ:
     - 🟢 **อนุมัติ (Approve)**
     - 🟡 **ขอแก้ไข (Request Revision)**: ระบุเหตุผล (เช่น รูปไม่ชัดเจน, ยอดไม่ตรง)
     - 🔴 **ปฏิเสธ (Reject)**
   - **PC:** ในหน้ารายการของสาขา หากมีรายการที่ Admin ขอแก้ไข จะมีสถานะ `⚠️ ขอให้แก้ไขข้อมูล` พร้อมปุ่ม **"แก้ไขข้อมูล"**
   - เมื่อ PC กดแก้ไข ระบบจะเปิดฟอร์มพร้อมข้อมูลเดิมและแสดงข้อความแจ้งเตือนจาก Admin ให้ PC ถ่ายรูปใหม่หรือแก้ไขข้อมูลแล้วกด **"ส่งข้อมูลผู้รับบัตรกำนัล"** เพื่อส่งให้ Admin ตรวจสอบอีกครั้ง

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

## 4. แผนผังการทำงานและการตรวจสอบสิทธิ์ (Audit & Revision Flow)

```mermaid
flowchart TD
    Start([1. เปิดหน้าเว็บ Landing]) --> Landing[2. แสดงโปสเตอร์ 2 แคมเปญ + เลือกสาขา + กรอกข้อมูล PC]
    Landing --> Kiosk[3. หน้าบริการ Kiosk ประจำสาขา]
    
    Kiosk --> SubmitForm[4. ลงทะเบียนลูกค้า → แนบรูป 2 ภาพ → ส่งข้อมูล]
    SubmitForm --> Conf[5. หน้ายืนยันสิทธิ์ / ออกรหัส Voucher]
    Conf -->|Next| SubmitForm
    Conf -->|ออก| Landing
    
    SubmitForm -. บันทึก Cloud D1 & R2 .-> Admin[6. Admin เข้าด้วยรหัส admin1234]
    
    Admin --> Decision{Admin ตรวจสอบเอกสาร}
    Decision -->|ถูกต้อง| Appr[🟢 อนุมัติสิทธิ์ (Issued/Approved)]
    Decision -->|ไม่ถูกต้อง/ไม่ชัดเจน| ReqRev[🟡 ส่งคำขอแก้ไข (Request Revision + ระบุเหตุผล)]
    Decision -->|ผิดเงื่อนไขสิ้นเชิง| Rej[🔴 ปฏิเสธ (Rejected)]
    
    ReqRev -. แจ้งเตือนสาขา .-> StoreLog[7. PC ดูหน้ารายการสาขา พบรายการต้องแก้ไข]
    StoreLog --> ReviseBtn[8. PC กดปุ่ม 'แก้ไขข้อมูล' → ฟอร์มเดิมเปิดพร้อมข้อความเตือน Admin]
    ReviseBtn --> ReUpload[9. PC ถ่ายภาพใหม่ / แก้ไขยอดเงิน → กดส่งข้อมูล]
    ReUpload -. ส่งกลับให้ Admin .-> Admin
```

---

## 5. เอกสารแนบและไฟล์อ้างอิงในระบบ (Attached Reference Files)
- **เว็บแอปพลิเคชันพร้อมใช้งาน:** `index.html` (Landing Posters, Exit "ออก", Admin Audit & Revision System)
- **รูปภาพโปสเตอร์ Campaign A (Haier x PTT):** `Ad AC PTT vc.png`
- **รูปภาพโปสเตอร์ Campaign B (Shop More Get More):** `Ad PM vc.jpg`
- **ไฟล์ข้อมูลสาขา (Dimension Store):** `Dimension Store.csv` / `Dimension Store.json`
- **ไฟล์ข้อมูลรุ่นสินค้า (Dimension Model):** `Dimension Model.csv` / `Dimension Model.json`
