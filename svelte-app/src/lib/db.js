import Database from 'better-sqlite3';
export const db = new Database('game.db');
db.pragma('journal_mode = WAL');
prepare();

function prepare() {
	db.exec(`
CREATE TABLE IF NOT EXISTS loginCodeHashes (
  hash TEXT NOT NULL PRIMARY KEY,
  email TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
  email TEXT NOT NULL PRIMARY KEY,
  name TEXT,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sessions (
  id TEXT NOT NULL PRIMARY KEY,
  user TEXT NOT NULL REFERENCES user(email),
  expires_at INTEGER NOT NULL
);
	`);
}

