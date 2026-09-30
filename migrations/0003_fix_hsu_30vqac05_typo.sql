-- Fix typo in model code: HSU-30UQAC05 -> HSU-30VQAC05 (for databases that already ran the old 0002)
DELETE FROM dimension_model WHERE model_code = 'HSU-30UQAC05';
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-30VQAC05', 'Haier', 'AC', 'Inverter', 1);
UPDATE submissions SET model_code = 'HSU-30VQAC05' WHERE model_code = 'HSU-30UQAC05';
UPDATE campaigns
SET eligible_model_codes = '["HSU-09VRRA055BF","HSU-12VRRA05BF","HSU-18VRRA05BF","HSU-12VQEC05","HSU-30VQAC05"]'
WHERE campaign_id = 'CAMP-2026-PTT-AC';
