-- V9: Bí cảnh / Ải

CREATE TABLE dungeon (
    id                 INT           PRIMARY KEY,
    code               VARCHAR(50)   NOT NULL,
    name               VARCHAR(50)   NOT NULL,
    type               VARCHAR(10)   NOT NULL DEFAULT 'SOLO',
    max_players        SMALLINT      NOT NULL DEFAULT 1,
    daily_limit        SMALLINT      NOT NULL DEFAULT 3,
    required_realm_id  SMALLINT      NULL,
    map_id             VARCHAR(30)   NOT NULL,
    description        TEXT          NULL,

    CONSTRAINT uq_dungeon_code  UNIQUE (code),
    CONSTRAINT fk_dungeon_realm FOREIGN KEY (required_realm_id) REFERENCES realm (id),
    CONSTRAINT ck_dungeon_type  CHECK (type IN ('SOLO', 'PARTY')),
    CONSTRAINT ck_dungeon_players CHECK (
        (type = 'SOLO' AND max_players = 1) OR (type = 'PARTY' AND max_players BETWEEN 2 AND 5)
    ),
    CONSTRAINT ck_dungeon_daily_limit CHECK (daily_limit > 0)
);

CREATE TABLE dungeon_stage (
    id                  INT        PRIMARY KEY,
    dungeon_id          INT        NOT NULL,
    stage_no            SMALLINT   NOT NULL,
    monsters            JSONB      NOT NULL,   -- [{"monster": "SOI_XAM", "count": 5}]
    time_limit_seconds  INT        NOT NULL DEFAULT 300,
    first_clear_reward  JSONB      NULL,       -- {"stone": 500, "items": [{"item": 402, "qty": 1}]}
    reward              JSONB      NULL,

    CONSTRAINT uq_dungeon_stage UNIQUE (dungeon_id, stage_no),
    CONSTRAINT fk_dungeon_stage_dungeon FOREIGN KEY (dungeon_id) REFERENCES dungeon (id) ON DELETE CASCADE,
    CONSTRAINT ck_dungeon_stage_no   CHECK (stage_no > 0),
    CONSTRAINT ck_dungeon_stage_time CHECK (time_limit_seconds > 0)
);

CREATE TABLE character_dungeon (
    character_id     BIGINT        NOT NULL,
    dungeon_id       INT           NOT NULL,
    highest_stage    SMALLINT      NOT NULL DEFAULT 0,
    best_time_ms     INT           NULL,
    attempts_today   SMALLINT      NOT NULL DEFAULT 0,   -- job reset lúc 0h
    last_attempt_at  TIMESTAMPTZ   NULL,

    CONSTRAINT pk_character_dungeon PRIMARY KEY (character_id, dungeon_id),
    CONSTRAINT fk_character_dungeon_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_character_dungeon_dungeon   FOREIGN KEY (dungeon_id)   REFERENCES dungeon (id),
    CONSTRAINT ck_character_dungeon_numbers
        CHECK (highest_stage >= 0 AND attempts_today >= 0 AND (best_time_ms IS NULL OR best_time_ms > 0))
);
