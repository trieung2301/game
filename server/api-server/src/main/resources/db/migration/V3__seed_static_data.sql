-- V3: Dữ liệu tĩnh ban đầu (MVP)
-- Quy ước id vật phẩm: 1xx hạt giống, 2xx linh thảo, 3xx đan dược, 4xx nguyên liệu, 5xx trang bị

-- =========================================================
-- Cảnh giới: required_exp = tu vi cần để đột phá lên tầng kế tiếp
-- =========================================================
INSERT INTO realm (id, code, name, major_stage, required_exp, breakthrough_rate, base_hp, base_mp, base_atk, base_def) VALUES
(1, 'LUYEN_KHI_1', 'Luyện Khí tầng 1',   'LUYEN_KHI',     1000, 0.9500,   100,   50,   10,   5),
(2, 'LUYEN_KHI_2', 'Luyện Khí tầng 2',   'LUYEN_KHI',     3000, 0.9000,   180,   90,   18,   9),
(3, 'LUYEN_KHI_3', 'Luyện Khí tầng 3',   'LUYEN_KHI',     8000, 0.6000,   300,  150,   30,  15),
(4, 'TRUC_CO_1',   'Trúc Cơ sơ kỳ',      'TRUC_CO',      20000, 0.8500,   700,  350,   70,  35),
(5, 'TRUC_CO_2',   'Trúc Cơ trung kỳ',   'TRUC_CO',      50000, 0.7500,  1100,  550,  110,  55),
(6, 'TRUC_CO_3',   'Trúc Cơ hậu kỳ',     'TRUC_CO',     120000, 0.4000,  1600,  800,  160,  80),
(7, 'KIM_DAN_1',   'Kim Đan sơ kỳ',      'KIM_DAN',     300000, 0.7000,  3500, 1750,  350, 175),
(8, 'KIM_DAN_2',   'Kim Đan trung kỳ',   'KIM_DAN',     700000, 0.6000,  5000, 2500,  500, 250),
(9, 'KIM_DAN_3',   'Kim Đan hậu kỳ',     'KIM_DAN',          0, 0.0000,  7000, 3500,  700, 350);
-- Kim Đan hậu kỳ là cảnh giới cao nhất của MVP: không đột phá tiếp

-- =========================================================
-- Vật phẩm
-- =========================================================
INSERT INTO item (id, code, name, type, rarity, max_stack, base_price, tradable, effect, equip_slot, base_stats, required_realm_id, description) VALUES
-- Hạt giống
(101, 'SEED_LINH_THAO',   'Hạt Linh Thảo',        'SEED', 'COMMON',    99,    5, TRUE, NULL, NULL, NULL, NULL, 'Hạt giống cơ bản, dễ trồng.'),
(102, 'SEED_HUYET_SAM',   'Hạt Huyết Sâm',        'SEED', 'COMMON',    99,   15, TRUE, NULL, NULL, NULL, NULL, 'Sâm đỏ như máu, bổ khí huyết.'),
(103, 'SEED_LINH_CHI',    'Bào tử Linh Chi',      'SEED', 'RARE',      99,   40, TRUE, NULL, NULL, NULL, 2,    'Linh chi trăm năm, cần linh khí dồi dào.'),
(104, 'SEED_BANG_LIEN',   'Hạt Băng Liên',        'SEED', 'RARE',      99,   80, TRUE, NULL, NULL, NULL, 4,    'Sen mọc trong băng, tính hàn.'),
(105, 'SEED_HOA_DUONG',   'Hạt Hỏa Dương Thảo',   'SEED', 'EPIC',      99,  200, TRUE, NULL, NULL, NULL, 6,    'Cỏ hấp thu dương hỏa, cực hiếm.'),
-- Linh thảo
(201, 'HERB_LINH_THAO',   'Linh Thảo',            'HERB', 'COMMON',   999,   10, TRUE, NULL, NULL, NULL, NULL, 'Nguyên liệu luyện đan cơ bản.'),
(202, 'HERB_HUYET_SAM',   'Huyết Sâm',            'HERB', 'COMMON',   999,   30, TRUE, NULL, NULL, NULL, NULL, 'Bổ máu, dùng luyện Hồi Xuân Đan.'),
(203, 'HERB_LINH_CHI',    'Linh Chi',             'HERB', 'RARE',     999,   90, TRUE, NULL, NULL, NULL, NULL, 'Tăng linh lực.'),
(204, 'HERB_BANG_LIEN',   'Băng Liên',            'HERB', 'RARE',     999,  180, TRUE, NULL, NULL, NULL, NULL, 'Tĩnh tâm, hỗ trợ đột phá.'),
(205, 'HERB_HOA_DUONG',   'Hỏa Dương Thảo',       'HERB', 'EPIC',     999,  450, TRUE, NULL, NULL, NULL, NULL, 'Chủ dược của Trúc Cơ Đan.'),
-- Đan dược
(301, 'PILL_TU_KHI',      'Tụ Khí Đan',           'PILL', 'COMMON',    99,   50, TRUE, '{"exp": 200}',                NULL, NULL, NULL, 'Tăng 200 tu vi.'),
(302, 'PILL_HOI_XUAN',    'Hồi Xuân Đan',         'PILL', 'COMMON',    99,   40, TRUE, '{"hp": 300}',                 NULL, NULL, NULL, 'Hồi 300 HP.'),
(303, 'PILL_HOI_LINH',    'Hồi Linh Đan',         'PILL', 'COMMON',    99,   40, TRUE, '{"mp": 200}',                 NULL, NULL, NULL, 'Hồi 200 MP.'),
(304, 'PILL_NGUNG_NGUYEN','Ngưng Nguyên Đan',     'PILL', 'RARE',      99,  400, TRUE, '{"exp": 2000}',               NULL, NULL, 4,    'Tăng 2000 tu vi.'),
(305, 'PILL_TRUC_CO',     'Trúc Cơ Đan',          'PILL', 'EPIC',      10, 3000, TRUE, '{"breakthrough_bonus": 0.3}', NULL, NULL, 3,    'Tăng 30% tỉ lệ đột phá Trúc Cơ.'),
-- Nguyên liệu (rơi từ quái)
(401, 'MAT_YEU_THU_COT',  'Yêu Thú Cốt',          'MATERIAL', 'COMMON', 999,  8, TRUE, NULL, NULL, NULL, NULL, 'Xương yêu thú, dùng rèn trang bị.'),
(402, 'MAT_YEU_DAN',      'Yêu Đan',              'MATERIAL', 'RARE',   999, 120, TRUE, NULL, NULL, NULL, NULL, 'Nội đan yêu thú, chứa linh lực.'),
(403, 'MAT_HUYEN_THIET',  'Huyền Thiết',          'MATERIAL', 'RARE',   999,  60, TRUE, NULL, NULL, NULL, NULL, 'Dùng cường hóa trang bị.'),
-- Trang bị
(501, 'EQ_MOC_KIEM',       'Mộc Kiếm',            'EQUIPMENT', 'COMMON', 1,   50, TRUE, NULL, 'WEAPON', '{"atk": 15}',            NULL, 'Kiếm gỗ cho người mới nhập môn.'),
(502, 'EQ_THANH_PHONG',    'Thanh Phong Kiếm',    'EQUIPMENT', 'RARE',   1,  800, TRUE, NULL, 'WEAPON', '{"atk": 80, "crit": 0.05}', 4, 'Kiếm nhẹ như gió.'),
(503, 'EQ_DAO_BAO',        'Đạo Bào',             'EQUIPMENT', 'COMMON', 1,   40, TRUE, NULL, 'ARMOR',  '{"def": 10, "hp": 50}',  NULL, 'Áo đạo sĩ thông thường.'),
(504, 'EQ_DAO_QUAN',       'Đạo Quán',            'EQUIPMENT', 'COMMON', 1,   30, TRUE, NULL, 'HELMET', '{"def": 5, "mp": 30}',   NULL, 'Mũ đạo sĩ.'),
(505, 'EQ_BO_HAI',         'Bố Hài',              'EQUIPMENT', 'COMMON', 1,   30, TRUE, NULL, 'BOOTS',  '{"def": 4, "speed": 0.05}', NULL, 'Giày vải, tăng tốc chạy.'),
(506, 'EQ_LINH_NGOC_GIOI', 'Linh Ngọc Giới',      'EQUIPMENT', 'RARE',   1,  600, TRUE, NULL, 'RING',   '{"mp": 150, "atk": 20}', 3,  'Nhẫn khảm linh ngọc.'),
(507, 'EQ_HO_THAN_PHU',    'Hộ Thân Phù',         'EQUIPMENT', 'RARE',   1,  500, TRUE, NULL, 'AMULET', '{"hp": 300, "def": 15}', 3,  'Bùa hộ mệnh.');

-- =========================================================
-- Cây trồng
-- =========================================================
INSERT INTO crop (id, seed_item_id, harvest_item_id, grow_seconds, yield_min, yield_max, required_realm_id) VALUES
(1, 101, 201,   300, 2, 4, NULL),   -- 5 phút
(2, 102, 202,   900, 1, 3, NULL),   -- 15 phút
(3, 103, 203,  3600, 1, 2, 2),      -- 1 giờ
(4, 104, 204, 14400, 1, 2, 4),      -- 4 giờ
(5, 105, 205, 43200, 1, 1, 6);      -- 12 giờ

-- =========================================================
-- Công thức luyện đan
-- =========================================================
INSERT INTO recipe (id, code, result_item_id, result_quantity, success_rate, duration_seconds, required_realm_id) VALUES
(1, 'RECIPE_TU_KHI',       301, 2, 0.9500,   60, NULL),
(2, 'RECIPE_HOI_XUAN',     302, 2, 0.9500,   60, NULL),
(3, 'RECIPE_HOI_LINH',     303, 2, 0.9500,   60, NULL),
(4, 'RECIPE_NGUNG_NGUYEN', 304, 1, 0.7000,  600, 4),
(5, 'RECIPE_TRUC_CO',      305, 1, 0.4000, 1800, 3);

INSERT INTO recipe_ingredient (recipe_id, item_id, quantity) VALUES
(1, 201, 3),
(2, 202, 2), (2, 201, 1),
(3, 201, 2), (3, 203, 1),
(4, 203, 3), (4, 204, 1), (4, 402, 1),
(5, 205, 1), (5, 204, 2), (5, 203, 3), (5, 402, 2);
