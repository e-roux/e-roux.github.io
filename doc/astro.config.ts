// @ts-check
import { defineConfig } from "astro/config";
import starlight from "@astrojs/starlight";
import { sidebar } from "./astro.sidebar";

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
    mdx(),
  ],

  vite: {
    plugins: [tailwindcss()],
  },
});
