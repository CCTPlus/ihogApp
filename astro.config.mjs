import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'iHog',
			logo: {
				src: './src/assets/icon.png',
				replacesTitle: true,
			},
			social: {
				github: 'https://github.com/cctplus/ihogApp',
			},
			sidebar: [
				{
					label: 'Releases',
					autogenerate: { directory: 'releases' },
				},
				{
					label: 'Developer',
					autogenerate: { directory: 'dev' },
				},
			],
		}),
	],
});
