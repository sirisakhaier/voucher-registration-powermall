-- Add HSU-30VQAC05 to the Haier x PTT campaign (existing databases; 0001 seed already updated for fresh installs)
INSERT OR REPLACE INTO dimension_model (model_code, brand, category, sub_category, is_active) VALUES ('HSU-30VQAC05', 'Haier', 'AC', 'Inverter', 1);
UPDATE campaigns
SET eligible_model_codes = '["HSU-09VRRA055BF","HSU-12VRRA05BF","HSU-18VRRA05BF","HSU-12VQEC05","HSU-30VQAC05"]'
WHERE campaign_id = 'CAMP-2026-PTT-AC';
