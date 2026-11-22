-- V6: Linh điền
-- Trạng thái ô ruộng tính từ dữ liệu, không lưu cột status:
--   crop_id IS NULL          -> ô trống
--   now() <  ready_at        -> đang lớn
--   now() >= ready_at        -> chín, thu hoạch được

CREATE TABLE farm_plot (
    id            BIGSERIAL     PRIMARY KEY,
    character_id  BIGINT        NOT NULL,
    plot_index    SMALLINT      NOT NULL,
    crop_id       INT           NULL,
    planted_at    TIMESTAMPTZ   NULL,
    ready_at      TIMESTAMPTZ   NULL,

    CONSTRAINT uq_farm_plot           UNIQUE (character_id, plot_index),
    CONSTRAINT fk_farm_plot_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_farm_plot_crop      FOREIGN KEY (crop_id)      REFERENCES crop (id),
    CONSTRAINT ck_farm_plot_index     CHECK (plot_index >= 0),
    -- Ô trống thì không có thời gian; ô có cây thì phải có đủ thời gian
    CONSTRAINT ck_farm_plot_state CHECK (
        (crop_id IS NULL AND planted_at IS NULL AND ready_at IS NULL)
        OR (crop_id IS NOT NULL AND planted_at IS NOT NULL AND ready_at > planted_at)
    )
);
