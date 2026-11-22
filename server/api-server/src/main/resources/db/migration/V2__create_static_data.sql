-- V2: Dữ liệu tĩnh (game designer định nghĩa, người chơi không sửa được)
-- id KHÔNG tự tăng: được gán cố định trong file seed (V3) để code và client tham chiếu ổn định

-- =========================================================
-- Cảnh giới
-- =========================================================
CREATE TABLE realm (
    id                 SMALLINT      PRIMARY KEY,
    code               VARCHAR(30)   NOT NULL,
    name               VARCHAR(50)   NOT NULL,
    major_stage        VARCHAR(20)   NOT NULL,
    required_exp       BIGINT        NOT NULL,
    breakthrough_rate  NUMERIC(5,4)  NOT NULL,
    base_hp            INT           NOT NULL,
    base_mp            INT           NOT NULL,
    base_atk           INT           NOT NULL,
    base_def           INT           NOT NULL,

    CONSTRAINT uq_realm_code  UNIQUE (code),
    CONSTRAINT uq_realm_name  UNIQUE (name),
    CONSTRAINT ck_realm_major_stage
        CHECK (major_stage IN ('LUYEN_KHI', 'TRUC_CO', 'KIM_DAN')),
    CONSTRAINT ck_realm_required_exp  CHECK (required_exp >= 0),
    CONSTRAINT ck_realm_rate          CHECK (breakthrough_rate BETWEEN 0 AND 1),
    CONSTRAINT ck_realm_stats
        CHECK (base_hp > 0 AND base_mp >= 0 AND base_atk >= 0 AND base_def >= 0)
);

-- =========================================================
-- Vật phẩm
-- =========================================================
CREATE TABLE item (
    id                 INT           PRIMARY KEY,
    code               VARCHAR(50)   NOT NULL,
    name               VARCHAR(100)  NOT NULL,
    type               VARCHAR(20)   NOT NULL,
    rarity             VARCHAR(10)   NOT NULL DEFAULT 'COMMON',
    max_stack          INT           NOT NULL DEFAULT 1,
    base_price         BIGINT        NOT NULL DEFAULT 0,
    tradable           BOOLEAN       NOT NULL DEFAULT TRUE,
    effect             JSONB         NULL,     -- đan dược: {"exp": 500}, {"hp": 200}
    equip_slot         VARCHAR(15)   NULL,     -- chỉ có với EQUIPMENT
    base_stats         JSONB         NULL,     -- trang bị: {"atk": 50, "def": 10}
    required_realm_id  SMALLINT      NULL,
    description        TEXT          NULL,

    CONSTRAINT uq_item_code UNIQUE (code),
    CONSTRAINT fk_item_realm FOREIGN KEY (required_realm_id) REFERENCES realm (id),
    CONSTRAINT ck_item_type
        CHECK (type IN ('SEED', 'HERB', 'PILL', 'MATERIAL', 'EQUIPMENT')),
    CONSTRAINT ck_item_rarity
        CHECK (rarity IN ('COMMON', 'RARE', 'EPIC', 'LEGENDARY')),
    CONSTRAINT ck_item_equip_slot_value
        CHECK (equip_slot IN ('WEAPON', 'ARMOR', 'HELMET', 'BOOTS', 'RING', 'AMULET')),
    CONSTRAINT ck_item_equip_slot_by_type CHECK (
        (type = 'EQUIPMENT' AND equip_slot IS NOT NULL)
        OR (type <> 'EQUIPMENT' AND equip_slot IS NULL)
    ),
    CONSTRAINT ck_item_equipment_not_stack
        CHECK (type <> 'EQUIPMENT' OR max_stack = 1),   -- trang bị không cộng dồn
    CONSTRAINT ck_item_max_stack   CHECK (max_stack > 0),
    CONSTRAINT ck_item_base_price  CHECK (base_price >= 0)
);

CREATE INDEX idx_item_type ON item (type);

-- =========================================================
-- Cây trồng: hạt giống -> thu hoạch
-- =========================================================
CREATE TABLE crop (
    id                 INT           PRIMARY KEY,
    seed_item_id       INT           NOT NULL,
    harvest_item_id    INT           NOT NULL,
    grow_seconds       INT           NOT NULL,
    yield_min          INT           NOT NULL DEFAULT 1,
    yield_max          INT           NOT NULL DEFAULT 1,
    required_realm_id  SMALLINT      NULL,

    CONSTRAINT uq_crop_seed     UNIQUE (seed_item_id),   -- 1 loại hạt = 1 loại cây
    CONSTRAINT fk_crop_seed     FOREIGN KEY (seed_item_id)      REFERENCES item (id),
    CONSTRAINT fk_crop_harvest  FOREIGN KEY (harvest_item_id)   REFERENCES item (id),
    CONSTRAINT fk_crop_realm    FOREIGN KEY (required_realm_id) REFERENCES realm (id),
    CONSTRAINT ck_crop_grow     CHECK (grow_seconds > 0),
    CONSTRAINT ck_crop_yield    CHECK (yield_min > 0 AND yield_max >= yield_min)
);

-- =========================================================
-- Công thức luyện đan
-- =========================================================
CREATE TABLE recipe (
    id                 INT           PRIMARY KEY,
    code               VARCHAR(50)   NOT NULL,
    result_item_id     INT           NOT NULL,
    result_quantity    INT           NOT NULL DEFAULT 1,
    success_rate       NUMERIC(5,4)  NOT NULL DEFAULT 1,
    duration_seconds   INT           NOT NULL DEFAULT 0,
    required_realm_id  SMALLINT      NULL,

    CONSTRAINT uq_recipe_code    UNIQUE (code),
    CONSTRAINT fk_recipe_result  FOREIGN KEY (result_item_id)    REFERENCES item (id),
    CONSTRAINT fk_recipe_realm   FOREIGN KEY (required_realm_id) REFERENCES realm (id),
    CONSTRAINT ck_recipe_quantity  CHECK (result_quantity > 0),
    CONSTRAINT ck_recipe_rate      CHECK (success_rate BETWEEN 0 AND 1),
    CONSTRAINT ck_recipe_duration  CHECK (duration_seconds >= 0)
);

-- Nguyên liệu của công thức (quan hệ nhiều-nhiều recipe <-> item)
CREATE TABLE recipe_ingredient (
    recipe_id  INT  NOT NULL,
    item_id    INT  NOT NULL,
    quantity   INT  NOT NULL,

    CONSTRAINT pk_recipe_ingredient PRIMARY KEY (recipe_id, item_id),
    CONSTRAINT fk_ingredient_recipe FOREIGN KEY (recipe_id) REFERENCES recipe (id) ON DELETE CASCADE,
    CONSTRAINT fk_ingredient_item   FOREIGN KEY (item_id)   REFERENCES item (id),
    CONSTRAINT ck_ingredient_quantity CHECK (quantity > 0)
);
