-- V12: Tông môn, bạn bè, thư
-- Tổ đội và chat realtime nằm ở Redis / game-server, không lưu DB.

CREATE TABLE sect (
    id                 BIGSERIAL     PRIMARY KEY,
    name               VARCHAR(30)   NOT NULL,
    leader_id          BIGINT        NOT NULL,
    level              SMALLINT      NOT NULL DEFAULT 1,
    contribution_pool  BIGINT        NOT NULL DEFAULT 0,
    announcement       VARCHAR(500)  NULL,
    created_at         TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT uq_sect_name   UNIQUE (name),
    CONSTRAINT fk_sect_leader FOREIGN KEY (leader_id) REFERENCES game_character (id),
    CONSTRAINT ck_sect_level  CHECK (level > 0),
    CONSTRAINT ck_sect_pool   CHECK (contribution_pool >= 0)
);
CREATE UNIQUE INDEX uq_sect_name_lower ON sect (LOWER(name));

CREATE TABLE sect_member (
    character_id  BIGINT        PRIMARY KEY,   -- mỗi người chỉ thuộc 1 tông môn
    sect_id       BIGINT        NOT NULL,
    rank          VARCHAR(10)   NOT NULL DEFAULT 'MEMBER',
    contribution  BIGINT        NOT NULL DEFAULT 0,
    joined_at     TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT fk_sect_member_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_sect_member_sect      FOREIGN KEY (sect_id)      REFERENCES sect (id) ON DELETE CASCADE,
    CONSTRAINT ck_sect_member_rank      CHECK (rank IN ('LEADER', 'ELDER', 'MEMBER')),
    CONSTRAINT ck_sect_member_contribution CHECK (contribution >= 0)
);
CREATE INDEX idx_sect_member_sect ON sect_member (sect_id);
-- Mỗi tông môn chỉ có 1 tông chủ
CREATE UNIQUE INDEX uq_sect_one_leader ON sect_member (sect_id) WHERE rank = 'LEADER';

-- Quan hệ bạn bè lưu 2 chiều: A->B và B->A
CREATE TABLE friendship (
    character_id  BIGINT        NOT NULL,
    friend_id     BIGINT        NOT NULL,
    status        VARCHAR(10)   NOT NULL DEFAULT 'PENDING',
    created_at    TIMESTAMPTZ   NOT NULL DEFAULT now(),

    CONSTRAINT pk_friendship PRIMARY KEY (character_id, friend_id),
    CONSTRAINT fk_friendship_character FOREIGN KEY (character_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_friendship_friend    FOREIGN KEY (friend_id)    REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT ck_friendship_not_self  CHECK (character_id <> friend_id),
    CONSTRAINT ck_friendship_status    CHECK (status IN ('PENDING', 'ACCEPTED', 'BLOCKED'))
);

CREATE TABLE mail (
    id           BIGSERIAL      PRIMARY KEY,
    receiver_id  BIGINT         NOT NULL,
    sender_id    BIGINT         NULL,      -- NULL = hệ thống
    title        VARCHAR(100)   NOT NULL,
    content      TEXT           NOT NULL DEFAULT '',
    attachments  JSONB          NULL,      -- {"stone": 1000, "items": [{"item": 301, "qty": 5}]}
    is_read      BOOLEAN        NOT NULL DEFAULT FALSE,
    claimed_at   TIMESTAMPTZ    NULL,
    expires_at   TIMESTAMPTZ    NOT NULL,
    created_at   TIMESTAMPTZ    NOT NULL DEFAULT now(),

    CONSTRAINT fk_mail_receiver FOREIGN KEY (receiver_id) REFERENCES game_character (id) ON DELETE CASCADE,
    CONSTRAINT fk_mail_sender   FOREIGN KEY (sender_id)   REFERENCES game_character (id) ON DELETE SET NULL,
    CONSTRAINT ck_mail_expires  CHECK (expires_at > created_at),
    CONSTRAINT ck_mail_claim    CHECK (claimed_at IS NULL OR attachments IS NOT NULL)
);
CREATE INDEX idx_mail_receiver ON mail (receiver_id, created_at DESC);
