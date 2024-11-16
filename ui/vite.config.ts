import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [sveltekit()],
  server: {
    proxy: {
      '/user': 'http://localhost:3333',
      '/game': 'http://localhost:3333',
    }
  }
});
