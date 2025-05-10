import { db } from "./db.js";
import { encodeBase32LowerCaseNoPadding, encodeHexLowerCase } from "@oslojs/encoding";
import { sha256 } from "@oslojs/crypto/sha2";

const CODE_VALID_FOR_MS = 1000 * 60 * 10; // 10 minutes
const SESSION_LENGTH = 1000 * 60 * 60 * 24 * 30; // 30 days
const SESSION_EXTENSION = SESSION_LENGTH / 2; // 15 days

function hashLoginCode(code) {
	return encodeHexLowerCase(sha256(new TextEncoder().encode(code)));
}

export function createLoginCode(email) {
	const bytes = new Uint8Array(4);
	crypto.getRandomValues(bytes);
	const code = encodeBase32LowerCaseNoPadding(bytes);
	const hash = hashLoginCode(code);
  const stmt = db.prepare("INSERT INTO loginCodeHashes (hash, email, expires_at) VALUES (?, ?, ?)");
  stmt.run(
    hash,
    email,
		(new Date(Date.now() + CODE_VALID_FOR_MS)).toISOString()
	);
  return code;
}

export function validateLoginCode(code, email) {
  // remove all old codes from db for sanitation
  db.prepare("DELETE FROM loginCodeHashes WHERE expires_at < ?")
    .run((new Date(Date.now())).toISOString());

  // now look for a remaining matching hash
	const hash = hashLoginCode(code);
  const stmt = db.prepare(
    "SELECT * FROM loginCodeHashes WHERE hash = ? AND email = ?"
  );
	const row = stmt.get(hash, email);
  console.log('row is', row);
  // nothing matching, return nulls
  return !!row;
}

export function generateSessionToken() {
	const bytes = new Uint8Array(20);
	crypto.getRandomValues(bytes);
	const token = encodeBase32LowerCaseNoPadding(bytes);
	return token;
}

export function createSession(token, userEmail) {
	const id = encodeHexLowerCase(sha256(new TextEncoder().encode(token)));
  const expiresAt = new Date(Date.now() + SESSION_LENGTH);
  const stmt = db.prepare("INSERT INTO sessions (id, user, expires_at) VALUES (?, ?, ?)");
  stmt.run(
		id,
		userEmail,
		Math.floor(expiresAt.getTime() / 1000)
	);
  return id;
}

export function validateSessionToken(token) {
	const sessionId = encodeHexLowerCase(sha256(new TextEncoder().encode(token)));
  const stmt = db.prepare(
    "SELECT sessions.id, sessions.user, sessions.expires_at, users.email FROM sessions INNER JOIN users ON users.email = sessions.user WHERE sessions.id = ?"
  );
	const row = stmt.get(sessionId);
  console.log('row is', row);
  // nothing matching, return nulls
	if (!row) {
		return { session: null, user: null };
	}
	const session = {
		id: row.id,
		user: row.user,
		expiresAt: new Date(row.expires_at * 1000)
	};
	const user = {
		email: row.email
	};
  // session is expired, so delete it.
	if (Date.now() >= session.expiresAt.getTime()) {
    invalidateSession(session.id);
		return { session: null, user: null };
	}
  // session is still active, extend it.
	if (Date.now() >= session.expiresAt.getTime() - SESSION_EXTENSION) {
		session.expiresAt = new Date(Date.now() + SESSION_LENGTH);
    const upd = db.prepare("UPDATE sessions SET expires_at = ? WHERE id = ?");
		upd.run(
			Math.floor(session.expiresAt.getTime() / 1000),
			session.id
		);
	}
	return { session, user };
}

export function invalidateSession(sessionId) {
  return db.prepare("DELETE FROM sessions WHERE id = ?").run(sessionId);
}
