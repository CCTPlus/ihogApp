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
					label: 'Guides',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: 'Example Guide', link: '/guides/example/' },
					],
				},
				{
					label: 'Reference',
					autogenerate: { directory: 'reference' },
				},
				{
					label: 'Developer',
					autogenerate: { directory: 'dev' },
				},
			],
		}),
	],
});
