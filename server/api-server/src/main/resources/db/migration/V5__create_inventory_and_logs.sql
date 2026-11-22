-- V5: Túi đồ (gồm cả trang bị) và log tiền/vật phẩm

CREATE TABLE inventory_item (
    id             BIGSERIAL     PRIMARY KEY,
    character_id   BIGINT        NOT NULL,
    item_id        INT           NOT NULL,
    quantity       INT           NOT NULL DEFAULT 1,
    slot_index     SMALLINT      NULL,     -- vị trí trong túi; NULL khi đang mặc
    equipped_slot  VARCHAR(15)   NULL,     -- vị trí đang mặc; NULL khi nằm trong túi
    enhance_level  SMALLINT      NOT NULL DEFAULT 0,
    bonus_stats    JSONB         NULL,     -- chỉ số random riêng của món trang bị
    bound          BOOLEAN       NOT NULL DEFAULT FALSE,  -- khóa giao dịch
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT fk_inventory_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_inventory_item      FOREIGN KEY (item_id)      REFERENCES item (id),
    CONSTRAINT ck_inventory_quantity  CHECK (quantity > 0),
    CONSTRAINT ck_inventory_slot      CHECK (slot_index IS NULL OR slot_index >= 0),
    CONSTRAINT ck_inventory_enhance   CHECK (enhance_level BETWEEN 0 AND 15),
    CONSTRAINT ck_inventory_equipped_slot
        CHECK (equipped_slot IN ('WEAPON', 'ARMOR', 'HELMET', 'BOOTS', 'RING', 'AMULET')),
    -- Hoặc nằm trong túi, hoặc đang mặc: đúng 1 trong 2
    CONSTRAINT ck_inventory_location CHECK (
        (slot_index IS NOT NULL AND equipped_slot IS NULL)
        OR (slot_index IS NULL AND equipped_slot IS NOT NULL)
    ),
    CONSTRAINT ck_inventory_equipped_single CHECK (equipped_slot IS NULL OR quantity = 1)
);

-- Mỗi ô túi chỉ chứa 1 chồng vật phẩm
CREATE UNIQUE INDEX uq_inventory_slot
    ON inventory_item (character_id, slot_index) WHERE slot_index IS NOT NULL;
-- Mỗi vị trí trang bị chỉ mặc 1 món
CREATE UNIQUE INDEX uq_inventory_equipped
    ON inventory_item (character_id, equipped_slot) WHERE equipped_slot IS NOT NULL;
CREATE INDEX idx_inventory_character_item ON inventory_item (character_id, item_id);

-- =========================================================
-- Log: chỉ INSERT, không UPDATE/DELETE
-- =========================================================
CREATE TABLE currency_log (
    id             BIGSERIAL     PRIMARY KEY,
    character_id   BIGINT        NOT NULL,
    amount         BIGINT        NOT NULL,        -- âm = trừ, dương = cộng
    balance_after  BIGINT        NOT NULL,
    reason         VARCHAR(30)   NOT NULL,        -- MARKET_BUY, MARKET_SELL, NPC_SELL, MONSTER_DROP...
    ref_id         BIGINT        NULL,            -- id listing / quest / dungeon liên quan
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT fk_currency_log_character FOREIGN KEY (character_id) REFERENCES game_character (id),
    CONSTRAINT ck_currency_log_amount    CHECK (amount <> 0),
    CONSTRAINT ck_currency_log_balance   CHECK (balance_after >= 0)
);
CREATE INDEX idx_currency_log_character ON currency_log (character_id, created_at DESC);

CREATE TABLE item_log (
    id             BIGSERIAL     PRIMARY KEY,
    character_id   BIGINT        NOT NULL,
    item_id        INT           NOT NULL,
    amount         INT           NOT NULL,        -- âm = mất, dương = nhận
    reason         VARCHAR(30)   NOT NULL,        -- HARVEST, ALCHEMY, MARKET_BUY, MONSTER_DROP, USE...
    ref_id         BIGINT        NULL,
    detail         JSONB         NULL,            -- chỉ số trang bị tại thời điểm giao dịch
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT fk_item_log_character FOREIGN KEY (character_id) REFERENCES game_character (id),
    CONSTRAINT fk_item_log_item      FOREIGN KEY (item_id)      REFERENCES item (id),
    CONSTRAINT ck_item_log_amount    CHECK (amount <> 0)
);
CREATE INDEX idx_item_log_character ON item_log (character_id, created_at DESC);
