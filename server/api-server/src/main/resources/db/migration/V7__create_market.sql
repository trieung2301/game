-- V7: Phường thị (chợ người chơi)
-- Khi treo bán, vật phẩm bị LẤY RA khỏi túi người bán (giữ hộ) để không bán 2 lần.
-- item_data lưu chỉ số trang bị (enhance_level, bonus_stats) để trả lại đúng món khi mua/hủy.

CREATE TABLE market_listing (
    id           BIGSERIAL     PRIMARY KEY,
    seller_id    BIGINT        NOT NULL,
    buyer_id     BIGINT        NULL,
    item_id      INT           NOT NULL,
    quantity     INT           NOT NULL,
    unit_price   BIGINT        NOT NULL,
    item_data    JSONB         NULL,
    status       VARCHAR(10)   NOT NULL DEFAULT 'ACTIVE',
    version      BIGINT        NOT NULL DEFAULT 0,     -- chống 2 người mua cùng lúc
    created_at   TIMESTAMPTZ   NOT NULL DEFAULT now(),
    expires_at   TIMESTAMPTZ   NOT NULL,
    closed_at    TIMESTAMPTZ   NULL,                   -- thời điểm bán / hủy / hết hạn

    CONSTRAINT fk_market_seller FOREIGN KEY (seller_id) REFERENCES game_character (id),
    CONSTRAINT fk_market_buyer  FOREIGN KEY (buyer_id)  REFERENCES game_character (id),
    CONSTRAINT fk_market_item   FOREIGN KEY (item_id)   REFERENCES item (id),
    CONSTRAINT ck_market_quantity CHECK (quantity > 0),
    CONSTRAINT ck_market_price    CHECK (unit_price > 0),
    CONSTRAINT ck_market_status   CHECK (status IN ('ACTIVE', 'SOLD', 'CANCELLED', 'EXPIRED')),
    CONSTRAINT ck_market_expires  CHECK (expires_at > created_at),
    CONSTRAINT ck_market_not_self CHECK (buyer_id IS NULL OR buyer_id <> seller_id),
    CONSTRAINT ck_market_sold CHECK (
        (status = 'SOLD' AND buyer_id IS NOT NULL AND closed_at IS NOT NULL)
        OR (status <> 'SOLD' AND buyer_id IS NULL)
    )
);

-- Tìm hàng đang bán theo vật phẩm, sắp theo giá
CREATE INDEX idx_market_active_item ON market_listing (item_id, unit_price) WHERE status = 'ACTIVE';
CREATE INDEX idx_market_seller      ON market_listing (seller_id, status);
-- Job quét hàng hết hạn
CREATE INDEX idx_market_expires     ON market_listing (expires_at) WHERE status = 'ACTIVE';
