-- Migration: 0001_init.sql
-- Cloudflare D1 Database Schema & Seed for Haier Voucher Registration

CREATE TABLE IF NOT EXISTS dimension_store (
    store_id TEXT PRIMARY KEY,
    store_name TEXT NOT NULL,
    store_name_th TEXT NOT NULL,
    customer_name TEXT DEFAULT 'เพาเวอร์มอลล์',
    store_id_customer TEXT,
    province_th TEXT NOT NULL,
    region_th TEXT NOT NULL,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS dimension_model (
    model_code TEXT PRIMARY KEY,
    brand TEXT NOT NULL DEFAULT 'Haier',
    category TEXT NOT NULL,
    sub_category TEXT NOT NULL,
    is_active INTEGER DEFAULT 1,
    remark TEXT,
    update_by TEXT DEFAULT 'admin',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS campaigns (
    campaign_id TEXT PRIMARY KEY,
    name_th TEXT NOT NULL,
    name_en TEXT NOT NULL,
    badge_label TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    eligible_store_ids TEXT,
    fixed_category TEXT,
    fixed_sub_category TEXT,
    eligible_model_codes TEXT,
    min_spend_thb REAL DEFAULT 0,
    reward_name TEXT NOT NULL,
    reward_value_thb REAL NOT NULL,
    reward_image_url TEXT,
    terms_conditions_th TEXT,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS submissions (
    submission_id TEXT PRIMARY KEY,
    store_id TEXT NOT NULL,
    campaign_id TEXT NOT NULL,
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    category TEXT NOT NULL,
    sub_category TEXT NOT NULL,
    model_code TEXT NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_amount_thb REAL NOT NULL,
    receipt_photo_url TEXT NOT NULL,
    voucher_photo_url TEXT NOT NULL,
    staff_name TEXT,
    staff_emp_id TEXT,
    voucher_status TEXT DEFAULT 'issued' CHECK(voucher_status IN ('pending', 'issued', 'rejected', 'redeemed')),
    voucher_code TEXT UNIQUE,
    redeemed_at DATETIME,
    admin_remark TEXT,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(store_id) REFERENCES dimension_store(store_id),
    FOREIGN KEY(campaign_id) REFERENCES campaigns(campaign_id)
);

CREATE INDEX IF NOT EXISTS idx_sub_store ON submissions(store_id);
CREATE INDEX IF NOT EXISTS idx_sub_campaign ON submissions(campaign_id);
CREATE INDEX IF NOT EXISTS idx_sub_phone ON submissions(customer_phone);
CREATE INDEX IF NOT EXISTS idx_sub_purchase_date ON submissions(purchase_date);

-- SEED CAMPAIGNS
INSERT OR REPLACE INTO campaigns (campaign_id, name_th, name_en, badge_label, start_date, end_date, eligible_store_ids, fixed_category, fixed_sub_category, eligible_model_codes, min_spend_thb, reward_name, reward_value_thb, is_active)
VALUES 
('CAMP-2026-PTT-AC', 'เย็นฉ่ำ แล้วยังเติมความสุขให้ทุกเส้นทาง (Haier x PTT)', 'Haier x PTT Campaign', 'รับฟรี บัตรเติมน้ำมัน PTT 500 บาท', '2026-08-01', '2026-08-31', NULL, 'AC', 'Inverter', '["HSU-09VRRA055BF","HSU-12VRRA05BF","HSU-18VRRA05BF","HSU-12VQEC05"]', 0, 'บัตรเติมน้ำมัน PTT มูลค่า 500 บาท', 500, 1),
('CAMP-2026-SPORTS-MALL', 'Shop More Get More (Haier x LFC x PSG)', 'Shop More Get More', 'รับฟรี Gift Voucher The Mall 1,000 บาท', '2026-08-22', '2026-09-30', '["S00449","S00327"]', NULL, NULL, NULL, 20000, 'Gift Voucher The Mall มูลค่า 1,000 บาท', 1000, 1);

-- SEED STORES

INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00222', 'PM-NAKHONRATCHASIMA', 'เดอะมอลล์ โคราช', 'เพาเวอร์มอลล์', '33KB', 'นครราชสีมา', 'ภาคตะวันออกเฉียงเหนือ', 1);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00349', 'PM:NGAMWONGWAN', 'เดอะมอลล์ งามวงศ์วาน', 'เพาเวอร์มอลล์', '15KB', 'นนทบุรี', 'กรุงเทพฯและภาคกลาง', 1);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00370', 'PM:THAPRA', 'เดอะมอลล์ ท่าพระ', 'เพาเวอร์มอลล์', '14KB', 'กรุงเทพมหานคร', 'กรุงเทพฯและภาคกลาง', 1);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00190', 'PM:BANGKAE', 'เดอะมอลล์ บางแค', 'เพาเวอร์มอลล์', '16KB', 'กรุงเทพมหานคร', 'กรุงเทพฯและภาคกลาง', 1);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00066', 'PM:BANGKAPI', 'เดอะมอลล์ บางกะปิ', 'เพาเวอร์มอลล์', '17KB', 'กรุงเทพมหานคร', 'กรุงเทพฯและภาคกลาง', 1);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00795', 'PM:RAMKAMHANG', 'เดอะมอลล์ รามคำแหง', 'เพาเวอร์มอลล์', '13KB', 'กรุงเทพมหานคร', 'กรุงเทพฯและภาคกลาง', 0);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00327', 'PM:EMPORIUM', 'เอ็มโพเรียม', 'เพาเวอร์มอลล์', '30KB', 'กรุงเทพมหานคร', 'กรุงเทพฯและภาคกลาง', 1);
INSERT OR REPLACE INTO dimension_store (store_id, store_name, store_name_th, customer_name, store_id_customer, province_th, region_th, is_active) VALUES ('S00449', 'PM:SIAM_PARAGON', 'สยามพารากอน', 'เพาเวอร์มอลล์', '34KB', 'กรุงเทพมหานคร', 'กรุงเทพฯและภาคกลาง', 1);

-- SEED MODELS (415 SKUs)
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-240BC', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-340BC-V3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-763BC2', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-2100PCS3-V3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-180VC3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-LF108', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-200DP60', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-905M', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-200HM2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-478C', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('BD-272', 'Haier', 'FZ', 'Vertical', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD100-BD14756', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW70-BP10829', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW80-BP12929', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW100-B14876', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW100-BP10HBI', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM100-1826T', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM120-1826T', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM140', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM140-1701RS', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM150-1701RS', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HTW75OXSY', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T85N2', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T130N2', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T140N2', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MDM448 KS', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS550 MS', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS600 GBR', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM18NS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM209I', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM20NS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-TMB34I', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-DMBX15 CS', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-DMBX18', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-BM325MI', 'Haier', 'RF', 'BM', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50K7UG', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65S6UG PRO', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H98S900UX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H58K6UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE58K6500UA', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32K66G', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32K66G PLUS', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE32K6500A', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H40K66G', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE40K6000', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE42K8000', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE42K8000A', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43D6FG', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE43B9600T', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45E(DG)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('CE-09VPCT', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VNS03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VQEC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VQEC05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VQRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VQRC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VRRA05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VRWA05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VRWA05SBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-09VTRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10VFA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10VIP03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10VNR03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10VRRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10VRWA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('CE-12VPCT', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VNS03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQEA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQEC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQEC05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQMC03', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQRC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VQRC05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VRRA05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VRRA05BF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VRWA05BF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VTBA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VTRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12VTRZ03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VFRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VIP03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05B', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05BBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05P', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05PBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05SBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05W', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRSA05WBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VRWA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VSWA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13VSWA03TBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-15VQRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-15VQRC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-15VQRC05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VNR03T(N)', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VNS03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VQEC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VQMC03', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VQRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VQRC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRSA05B', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRSA05BBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRSA05P', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRSA05PBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRSA05SBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRSA05W', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRWA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRWA05', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VRWA05BF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VSWA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VSWA03TBF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18VTRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24VQRC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24VRRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24VRRA05BF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24VRWA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24VRWA05BF', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24VTRA03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-30VQAC03T', 'Haier', 'AC', 'Inverter', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10CQAA03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10CQRD03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-10CTC03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12CQRB03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-12CTB03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13CQAA03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13CQRD03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13CTC03T(H)', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-13CTR03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18CQRA03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18CQRB03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18CQRD03T(PIPE_IN)', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-18CTB03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24CQAA03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24CQRA03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24CTB03T', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-24CTC03T(H)', 'Haier', 'AC', 'Fix Speed', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HPU-24FSE03T', 'Haier', 'AC', 'Floor Standing', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LC-90', 'Haier', 'FZ', 'Wine', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('JC-116', 'Haier', 'FZ', 'Wine', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('TCFW-190U', 'Haier', 'FZ', 'Wine', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('JC-198', 'Haier', 'FZ', 'Wine', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('JC-360', 'Haier', 'FZ', 'Wine', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('JC-366DZ', 'Haier', 'FZ', 'Wine', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-240BC-V3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-310BC', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-340BC-V4', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-340BPC', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-340M', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-412BC-V2', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-412BPC', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-763BC3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-768BPCS3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-652BPC', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-781WSC', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-1700PCS2-V5', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-1065VC3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-2100PCS3-V4', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-1080VC3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SC-2600PCS3-V3', 'Haier', 'FZ', 'Beverage', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('BD-91', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-108C2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-108P2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-100HM', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-208C2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-208P2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-LF208', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-SB208', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-145HM', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-145HM2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-228C2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-228P2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-LF228', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-SB228', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-200GLF', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-200HM', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SD-217P', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-300DP', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-350DP', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-428DP', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-478DPV2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-478DP', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-478M', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-568DP', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-568DPV2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-568M', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-728C', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-728DP', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HCF-728DPV2', 'Haier', 'FZ', 'Chest', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SD-332D', 'Haier', 'FZ', 'Glass', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SD-332DP', 'Haier', 'FZ', 'Glass', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SD-407DP', 'Haier', 'FZ', 'Glass', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('SD-517DP', 'Haier', 'FZ', 'Glass', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('BD-151B', 'Haier', 'FZ', 'Vertical', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('BD-151C', 'Haier', 'FZ', 'Vertical', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('BD-276B', 'Haier', 'FZ', 'Vertical', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HDV70E1', 'Haier', 'WM', 'Dryer', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HDV70E1(CB)', 'Haier', 'WM', 'Dryer', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HDV80E1', 'Haier', 'WM', 'Dryer', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HD100-A357S8', 'Haier', 'WM', 'Dryer', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HD100-AR959S', 'Haier', 'WM', 'Dryer', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HD140-AR367S8U1', 'Haier', 'WM', 'Dryer', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD100-BP12357S8', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD100-BP14959S8', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD100-B14876U1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD130-BP14959S8', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD140-BD14LCGNU1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD140-BP14367S8U1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD140-BPD14387GNU1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD150-B1601U1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD150-BP14986ES8U1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWD210-BD12LGNU1', 'Haier', 'WM', 'FL Wash&Dry', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW80-BP10829(CB)', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW80-BP12929A', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW90-BP12357S8', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW90-BP14959', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW95-BP14929AS6', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW100-BP12357S8', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW100-BP14959S6', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW105-BP14929AS6', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW120-BP12357S8', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW120-BP14367S8U1', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW120-BP14929AS6', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW120-BP14959S6', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW140-BD14697WU1', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW140-BP14367S8U1', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW140-BPD14387GNU1', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW150-BP14986ES9', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HW180-BPD14387GNU1', 'Haier', 'WM', 'Front Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM80-316S6', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM100-1701R(CB)', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM100-316S6', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM120-1701RS', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM120-316S6', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM130-B1678ES8', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM140-1701D', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM140-1702DS', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM140-1826T', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM150-316S6', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM150-B1678ES8', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM160-1701D', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM160-B2178S8', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM160-B278S6', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM180-B1678S8', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM180-B2178S8', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM180-B278S6', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM200-B1678ES8', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM200-B2158B', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM250-1701D', 'Haier', 'WM', 'Top Load', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HTW70-1217BS', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HTW90-1217BS', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T100 OXI', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HTW110-1217BS', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T120 OXI', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HTW130-1217BS', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HTW150-1217BS', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T160N2', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T180N2', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HWM-T200N2', 'Haier', 'WM', 'Twin Tub', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD350 GB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD419M', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD456 GB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD469G GB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD469G HPW', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD469M MB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD469WG', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD529I(MLW)GU1', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-FD529I(MLW)GU1', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD539IW(GL)U1', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD539GBT', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD550GB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD620GB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD758SIBGU1', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-MD679GB', 'Haier', 'RF', 'Multi Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS490 SV', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('RSB59CRFD1OL', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS569MS CB', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS569MS HP', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS636 MS', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-SBS636IW(SLB)U1', 'Haier', 'RF', 'SBS', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-185MN', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-209MNI BK', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-209MNI HPMS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-215MN SS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-RT205MN NS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-239MNI BK', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-245MN SS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-RT235MN NS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-240MNI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM259I', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM25NS', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-260MGI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-285MNI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-350MNI BK', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-320MNI BK', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM42I', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-THM42N', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-455MNI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-460IMGU1', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-460MGI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-460MNI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-490IWMGU1', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-490MGI', 'Haier', 'RF', '2Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD55', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD95', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-ADBX15 CB', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-ADBX15 CS', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-DMBX15 CB', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-DMBX15 CG', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD149M MB', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD159F BE', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD159F CS', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD159F HPG', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-DMBX18 CB', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-DMBX18 CS', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD189M MB', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD199F BE', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HR-SD199F CS', 'Haier', 'RF', '1Dr', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HRF-BM329MI', 'Haier', 'RF', 'BM', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65C900UX', 'Haier', 'TV', 'OLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55M80FUX', 'Haier', 'TV', 'MINI-LED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65M80FUX', 'Haier', 'TV', 'MINI-LED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75M80FUX', 'Haier', 'TV', 'MINI-LED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75M95EUX', 'Haier', 'TV', 'MINI-LED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H85M80FUX', 'Haier', 'TV', 'MINI-LED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32S80EFX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43S80EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43S80GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50S80EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50S80GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55K7UG', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55S80EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55S80GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55S900UX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55S90EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65K7UG', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65S80EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65S80GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65S90EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75K7UG', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75S800UX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75S80GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75S90EUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H85S800UX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H85S80GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H100S90GUX', 'Haier', 'TV', 'QLED', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32K70G', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43K85FFX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50K66UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50K6UG PLUS', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50K85FUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE50K8000UA', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55K66UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55K6UG PLUS', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55K85FUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55K85GUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H58K66UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H58K67UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65K6UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65K85FUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H65K85GUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H70D6UG', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75K85FUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H75K85GUX', 'Haier', 'TV', 'UHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('32H5F', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32D6M', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32F6000', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H32S70GFX', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE32B9600T', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE32K6000', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE39K8000', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('LE39K8000A', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H40K6FG PLUS', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43D5F', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43K6FG', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43K6FG PLUS', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H43S70GFX', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H50S70GFX', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('H55D6UG', 'Haier', 'TV', 'FHD', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35E(DW)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35E-F3CS(TH)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35G1(S)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35G2(G)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35H2(B)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45E-F3CS(TH)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45E-K5CB(TH)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45G2(G)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45H2(B)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI55E-K5CB-RS(TH)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI60C1(W)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI60E(DB)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI60E-PAD5AB(TH)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI60G2(G)', 'Haier', 'WH', 'Digital', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35A1(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35A2(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35L1(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35M(AES)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35M-D1W(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35M-F1CWB(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35M-F1W(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI35M1(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45A1(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45A2(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45H1(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M(AE)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M-B1W(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M-D1W(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M-F1CWB(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M-F1W(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M-J1CW-F(TH)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('EI45M1(W)', 'Haier', 'WH', 'Manual', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HDC-BB3A1B-TH', 'Haier', 'WH', 'Water Dispenser', 1);
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HDC-TB3B1W-TH', 'Haier', 'WH', 'Water Dispenser', 1);
