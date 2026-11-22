-- V11: PK ngoài map và đấu trường xếp hạng

CREATE TABLE pk_log (
    id             BIGSERIAL     PRIMARY KEY,
    killer_id      BIGINT        NOT NULL,
    victim_id      BIGINT        NOT NULL,
    map_id         VARCHAR(30)   NOT NULL,
    dropped_items  JSONB         NULL,      -- đồ rơi khi chết (nếu có luật rơi đồ)
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT fk_pk_log_killer FOREIGN KEY (killer_id) REFERENCES game_character (id),
    CONSTRAINT fk_pk_log_victim FOREIGN KEY (victim_id) REFERENCES game_character (id),
    CONSTRAINT ck_pk_log_not_self CHECK (killer_id <> victim_id)
);
CREATE INDEX idx_pk_log_killer ON pk_log (killer_id, created_at DESC);
CREATE INDEX idx_pk_log_victim ON pk_log (victim_id, created_at DESC);

CREATE TABLE arena_season (
    id        INT           PRIMARY KEY,
    name      VARCHAR(50)   NOT NULL,
    start_at  TIMESTAMPTZ   NOT NULL,
    end_at    TIMESTAMPTZ   NOT NULL,
    rewards   JSONB         NULL,      -- [{"rank_from": 1, "rank_to": 1, "stone": 10000}]

    CONSTRAINT ck_arena_season_time CHECK (end_at > start_at)
);

CREATE TABLE arena_rating (
    season_id     INT       NOT NULL,
    character_id  BIGINT    NOT NULL,
    rating        INT       NOT NULL DEFAULT 1000,   -- ELO
    wins          INT       NOT NULL DEFAULT 0,
    losses        INT       NOT NULL DEFAULT 0,
    draws         INT       NOT NULL DEFAULT 0,

    CONSTRAINT pk_arena_rating PRIMARY KEY (season_id, character_id),
    CONSTRAINT fk_arena_rating_season    FOREIGN KEY (season_id)    REFERENCES arena_season (id),
    CONSTRAINT fk_arena_rating_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT ck_arena_rating_numbers CHECK (rating >= 0 AND wins >= 0 AND losses >= 0 AND draws >= 0)
);
CREATE INDEX idx_arena_rating_rank ON arena_rating (season_id, rating DESC);

CREATE TABLE arena_match (
    id             BIGSERIAL     PRIMARY KEY,
    season_id      INT           NOT NULL,
    player1_id     BIGINT        NOT NULL,
    player2_id     BIGINT        NOT NULL,
    winner_id      BIGINT        NULL,      -- NULL = hòa
    rating_change  INT           NOT NULL DEFAULT 0,
    duration_ms    INT           NOT NULL,
    created_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT fk_arena_match_season  FOREIGN KEY (season_id)  REFERENCES arena_season (id),
    CONSTRAINT fk_arena_match_player1 FOREIGN KEY (player1_id) REFERENCES game_character (id),
    CONSTRAINT fk_arena_match_player2 FOREIGN KEY (player2_id) REFERENCES game_character (id),
    CONSTRAINT ck_arena_match_players CHECK (player1_id <> player2_id),
    CONSTRAINT ck_arena_match_winner
        CHECK (winner_id IS NULL OR winner_id IN (player1_id, player2_id)),
    CONSTRAINT ck_arena_match_duration CHECK (duration_ms > 0)
);
CREATE INDEX idx_arena_match_player1 ON arena_match (player1_id, created_at DESC);
CREATE INDEX idx_arena_match_player2 ON arena_match (player2_id, created_at DESC);
