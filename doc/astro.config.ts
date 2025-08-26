// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import { sidebar } from "./astro.sidebar";
import devToolbarIntegration from "./astro-dev-toolbar-app/integration.js";

import mdx from "@astrojs/mdx";

import tailwindcss from "@tailwindcss/vite";

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: "My Docs",
			customCss: ["./src/styles/global.css"],
			social: [],
			sidebar,
			pagination: false,
		}),
		mdx({
			syntaxHighlight: "shiki", // https://shiki.style/themes
			shikiConfig: {
				themes: {
					light: "everforest-light",
					dark: "everforest-dark",
				},
			},
		}),
		devToolbarIntegration(),
	],

	vite: {
		server: {
			fs: {
				strict: true,
			},
		},
		plugins: [tailwindcss()],
	},
});
