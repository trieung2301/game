-- V10: Nhiệm vụ

CREATE TABLE quest (
    id                 INT            PRIMARY KEY,
    code               VARCHAR(50)    NOT NULL,
    name               VARCHAR(100)   NOT NULL,
    type               VARCHAR(10)    NOT NULL,
    chapter            SMALLINT       NULL,      -- nhiệm vụ chính thuộc chương nào
    prev_quest_id      INT            NULL,      -- phải hoàn thành nhiệm vụ trước
    npc_code           VARCHAR(50)    NULL,      -- NPC giao nhiệm vụ
    objectives         JSONB          NOT NULL,  -- [{"type": "KILL", "target": "SOI_XAM", "count": 10}]
    rewards            JSONB          NOT NULL,  -- {"exp": 500, "stone": 100, "items": [...]}
    required_realm_id  SMALLINT       NULL,
    description        TEXT           NULL,

    CONSTRAINT uq_quest_code  UNIQUE (code),
    CONSTRAINT fk_quest_prev  FOREIGN KEY (prev_quest_id)     REFERENCES quest (id),
    CONSTRAINT fk_quest_realm FOREIGN KEY (required_realm_id) REFERENCES realm (id),
    CONSTRAINT ck_quest_type  CHECK (type IN ('MAIN', 'SIDE', 'DAILY')),
    CONSTRAINT ck_quest_main_chapter CHECK (type <> 'MAIN' OR chapter IS NOT NULL),
    CONSTRAINT ck_quest_objectives   CHECK (jsonb_typeof(objectives) = 'array')
);

CREATE TABLE character_quest (
    character_id  BIGINT        NOT NULL,
    quest_id      INT           NOT NULL,
    status        VARCHAR(12)   NOT NULL DEFAULT 'IN_PROGRESS',
    progress      JSONB         NOT NULL DEFAULT '[]',   -- [3, 5]: tiến độ từng mục tiêu
    accepted_at   TIMESTAMPTZ   NOT NULL DEFAULT now(),
    completed_at  TIMESTAMPTZ   NULL,
    claimed_at    TIMESTAMPTZ   NULL,

    CONSTRAINT pk_character_quest PRIMARY KEY (character_id, quest_id),
    CONSTRAINT fk_character_quest_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_character_quest_quest     FOREIGN KEY (quest_id)     REFERENCES quest (id),
    CONSTRAINT ck_character_quest_status CHECK (status IN ('IN_PROGRESS', 'COMPLETED', 'CLAIMED'))
);
CREATE INDEX idx_character_quest_status ON character_quest (character_id, status);
