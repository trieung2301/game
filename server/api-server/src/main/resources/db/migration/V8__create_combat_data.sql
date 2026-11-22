-- V8: Chiến đấu
-- Trận đánh chạy trong RAM của game-server. DB chỉ lưu định nghĩa và kết quả.

-- =========================================================
-- Kỹ năng (tĩnh)
-- =========================================================
CREATE TABLE skill (
    id                 INT           PRIMARY KEY,
    code               VARCHAR(50)   NOT NULL,
    name               VARCHAR(50)   NOT NULL,
    type               VARCHAR(10)   NOT NULL,
    target             VARCHAR(10)   NOT NULL,
    mp_cost            INT           NOT NULL DEFAULT 0,
    cooldown_ms        INT           NOT NULL DEFAULT 0,
    cast_range         REAL          NOT NULL DEFAULT 0,
    max_level          SMALLINT      NOT NULL DEFAULT 10,
    effect             JSONB         NOT NULL,     -- {"damage_ratio": 1.5, "per_level": 0.1}
    required_realm_id  SMALLINT      NULL,
    description        TEXT          NULL,

    CONSTRAINT uq_skill_code  UNIQUE (code),
    CONSTRAINT fk_skill_realm FOREIGN KEY (required_realm_id) REFERENCES realm (id),
    CONSTRAINT ck_skill_type   CHECK (type IN ('ACTIVE', 'PASSIVE')),
    CONSTRAINT ck_skill_target CHECK (target IN ('SELF', 'SINGLE', 'AOE')),
    CONSTRAINT ck_skill_numbers
        CHECK (mp_cost >= 0 AND cooldown_ms >= 0 AND cast_range >= 0 AND max_level > 0)
);

CREATE TABLE character_skill (
    character_id  BIGINT    NOT NULL,
    skill_id      INT       NOT NULL,
    level         SMALLINT  NOT NULL DEFAULT 1,
    hotbar_slot   SMALLINT  NULL,     -- ô phím tắt 1-8

    CONSTRAINT pk_character_skill PRIMARY KEY (character_id, skill_id),
    CONSTRAINT fk_character_skill_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_character_skill_skill     FOREIGN KEY (skill_id)     REFERENCES skill (id),
    CONSTRAINT ck_character_skill_level  CHECK (level > 0),
    CONSTRAINT ck_character_skill_hotbar CHECK (hotbar_slot IS NULL OR hotbar_slot BETWEEN 1 AND 8)
);
CREATE UNIQUE INDEX uq_character_skill_hotbar
    ON character_skill (character_id, hotbar_slot) WHERE hotbar_slot IS NOT NULL;

-- =========================================================
-- Quái (tĩnh). Vị trí xuất hiện nằm trong file map JSON (Tiled).
-- =========================================================
CREATE TABLE monster (
    id               INT           PRIMARY KEY,
    code             VARCHAR(50)   NOT NULL,
    name             VARCHAR(50)   NOT NULL,
    type             VARCHAR(10)   NOT NULL DEFAULT 'NORMAL',
    level            SMALLINT      NOT NULL,
    hp               INT           NOT NULL,
    atk              INT           NOT NULL,
    def              INT           NOT NULL,
    move_speed       REAL          NOT NULL DEFAULT 1,
    attack_range     REAL          NOT NULL DEFAULT 1,
    exp_reward       INT           NOT NULL DEFAULT 0,
    stone_min        INT           NOT NULL DEFAULT 0,
    stone_max        INT           NOT NULL DEFAULT 0,
    respawn_seconds  INT           NOT NULL DEFAULT 30,
    ai_type          VARCHAR(15)   NOT NULL DEFAULT 'PASSIVE',

    CONSTRAINT uq_monster_code UNIQUE (code),
    CONSTRAINT ck_monster_type  CHECK (type IN ('NORMAL', 'ELITE', 'BOSS')),
    CONSTRAINT ck_monster_ai    CHECK (ai_type IN ('PASSIVE', 'AGGRESSIVE', 'RANGED')),
    CONSTRAINT ck_monster_stats CHECK (level > 0 AND hp > 0 AND atk >= 0 AND def >= 0),
    CONSTRAINT ck_monster_stone CHECK (stone_min >= 0 AND stone_max >= stone_min),
    CONSTRAINT ck_monster_respawn CHECK (respawn_seconds > 0)
);

CREATE TABLE monster_drop (
    monster_id    INT           NOT NULL,
    item_id       INT           NOT NULL,
    drop_rate     NUMERIC(6,5)  NOT NULL,     -- 0.05000 = 5%
    quantity_min  INT           NOT NULL DEFAULT 1,
    quantity_max  INT           NOT NULL DEFAULT 1,

    CONSTRAINT pk_monster_drop PRIMARY KEY (monster_id, item_id),
    CONSTRAINT fk_monster_drop_monster FOREIGN KEY (monster_id) REFERENCES monster (id) ON DELETE CASCADE,
    CONSTRAINT fk_monster_drop_item    FOREIGN KEY (item_id)    REFERENCES item (id),
    CONSTRAINT ck_monster_drop_rate     CHECK (drop_rate > 0 AND drop_rate <= 1),
    CONSTRAINT ck_monster_drop_quantity CHECK (quantity_min > 0 AND quantity_max >= quantity_min)
);

-- Boss xuất hiện theo lịch (tĩnh)
CREATE TABLE world_boss_schedule (
    id          INT           PRIMARY KEY,
    monster_id  INT           NOT NULL,
    map_id      VARCHAR(30)   NOT NULL,
    cron        VARCHAR(50)   NOT NULL,     -- Spring cron: '0 0 20 * * *' = 20h mỗi ngày
    enabled     BOOLEAN       NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_world_boss_monster FOREIGN KEY (monster_id) REFERENCES monster (id)
);
