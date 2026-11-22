-- V4: Nhân vật (mỗi tài khoản 1 nhân vật)
-- Tên bảng game_character vì CHARACTER là từ khóa SQL

CREATE TABLE game_character (
    id             BIGSERIAL     PRIMARY KEY,
    account_id     BIGINT        NOT NULL,
    name           VARCHAR(20)   NOT NULL,
    realm_id       SMALLINT      NOT NULL DEFAULT 1,
    exp            BIGINT        NOT NULL DEFAULT 0,
    spirit_stone   BIGINT        NOT NULL DEFAULT 0,      -- linh thạch
    hp             INT           NOT NULL,
    mp             INT           NOT NULL,
    map_id         VARCHAR(30)   NOT NULL DEFAULT 'VILLAGE',
    pos_x          REAL          NOT NULL DEFAULT 0,
    pos_y          REAL          NOT NULL DEFAULT 0,
    story_chapter  SMALLINT      NOT NULL DEFAULT 1,
    pk_mode        VARCHAR(10)   NOT NULL DEFAULT 'PEACE',
    pk_points      INT           NOT NULL DEFAULT 0,      -- sát khí
    version        BIGINT        NOT NULL DEFAULT 0,      -- optimistic lock (@Version)
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT uq_character_account UNIQUE (account_id),
    CONSTRAINT uq_character_name    UNIQUE (name),
    CONSTRAINT fk_character_account FOREIGN KEY (account_id) REFERENCES account (id),
    CONSTRAINT fk_character_realm   FOREIGN KEY (realm_id)   REFERENCES realm (id),
    CONSTRAINT ck_character_exp          CHECK (exp >= 0),
    CONSTRAINT ck_character_spirit_stone CHECK (spirit_stone >= 0),
    CONSTRAINT ck_character_hp_mp        CHECK (hp >= 0 AND mp >= 0),
    CONSTRAINT ck_character_pk_mode      CHECK (pk_mode IN ('PEACE', 'SECT', 'ALL')),
    CONSTRAINT ck_character_pk_points    CHECK (pk_points >= 0),
    CONSTRAINT ck_character_chapter      CHECK (story_chapter > 0)
);

CREATE UNIQUE INDEX uq_character_name_lower ON game_character (LOWER(name));
-- Phục vụ bảng xếp hạng dự phòng khi Redis trống
CREATE INDEX idx_character_realm_exp ON game_character (realm_id DESC, exp DESC);
