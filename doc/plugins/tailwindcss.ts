import type { LoadContext, Plugin, PluginOptions } from '@docusaurus/types';
import tailwindcss from "@tailwindcss/postcss";

/*
Configuration for plugin: see the lifecycle API documentation
  https://docusaurus.io/docs/api/plugin-methods/lifecycle-apis

Specific for configurePostCss:
  https://docusaurus.io/docs/api/plugin-methods/lifecycle-apis#configurePostCss
*/

export default function tailwindPlugin(context: LoadContext, options: PluginOptions): Plugin {
  return {
    name: 'tailwind-plugin',
    configurePostCss(opts) {
      opts.plugins.push(tailwindcss);
      return opts;
    },
  };
};

