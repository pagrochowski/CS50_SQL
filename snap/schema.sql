EXPLAIN QUERY PLAN 

CREATE TABLE IF NOT EXISTS "users" (
    "id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "phone_number" TEXT NOT NULL UNIQUE,
    "joined_date" NUMERIC NOT NULL,
    "last_login_date" NUMERIC NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "friends" (
    "user_id" INTEGER,
    "friend_id" INTEGER,
    "friendship_date" NUMERIC NOT NULL,
    PRIMARY KEY("user_id", "friend_id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("friend_id") REFERENCES "users"("id")
);
CREATE TABLE IF NOT EXISTS "messages" (
    "id" INTEGER,
    "from_user_id" INTEGER,
    "to_user_id" INTEGER,
    "picture" TEXT NOT NULL,
    "sent_timestamp" NUMERIC NOT NULL,
    "viewed_timestamp" NUMERIC DEFAULT NULL,
    "expires_timestamp" NUMERIC DEFAULT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("from_user_id") REFERENCES "users"("id"),
    FOREIGN KEY("to_user_id") REFERENCES "users"("id")
);
CREATE INDEX "search_users_by_last_login"
ON "users"("last_login_date");
CREATE INDEX "search_messages_by_from_user_id"
ON "messages"("from_user_id");
CREATE INDEX "search_messages_by_to_user_id"
ON "messages"("to_user_id");