/** @satisfies {import('./$types').Actions} */
import { createSession, generateSessionToken, createLoginCode, validateLoginCode } from '$lib/sessions.js';
import { getUser, createUser } from '$lib/users.js';
import { send } from '$lib/email.js';

export const actions = {
	makeCode: async ({ request }) => {
    const data = await request.formData();
    let email = data.get('email');
    if (!!email) {
      email = email.toLowerCase();
      const code = createLoginCode(email);
      await send(email, 'noreply@solar-wars.com', `your login code is ${code}`, "You're invited to a game of solar-wars");
    }
    return { needCode: true, email };
	},
  checkCode: async ({ request, cookies }) => {
    const data = await request.formData();
    let code = data.get('code');
    let email = data.get('email');
    console.log(code, email);
    if (!!code && !!email) {
      if (validateLoginCode(code, email)) {
        const user = getUser(email);
        if (!user) {
          createUser(email);
        }
        const token = generateSessionToken();
        createSession(token, email);
        cookies.set('session', token, { path: '/' });
        redirect(303, "") // TODO
      } else {
        return { error: "code not valid" };
      }
    }
	},
};
