import { db } from "./db.js";

export function getUser(email) {
  const userStmt = db.prepare(
    "SELECT * FROM users WHERE email = ? LIMIT 1"
  );
	return userStmt.get(email);
}

export function createUser(email) {
  const ins = db.prepare("INSERT INTO users (email) VALUES (?)");
  return ins.run(email);
}

