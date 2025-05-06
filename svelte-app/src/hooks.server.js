import { validateSessionToken } from "$lib/sessions.js";

export async function handle({ event, resolve }) {
  const token = event.cookies.get("session");
  if (token !== null) {
    const { session, user } = validateSessionToken(token);
    event.locals.user = user;
  }

	return await resolve(event);
}
