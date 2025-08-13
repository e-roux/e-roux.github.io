import { Plugin } from '@docusaurus/types';
import path from "path";

export default function componentAliasPlugin(context, options) {
  return {
    name: "component-alias-plugin",
    configureWebpack() {
      return {
        resolve: {
          alias: {
            "@components": '@site/src/components/',
          },
        },
        ignoreWarnings: [
          /Module not found: Error: Package path .* is not exported from package/,
        ],
      };
    },
  };
}

