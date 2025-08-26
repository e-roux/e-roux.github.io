/**
 * @type {() => import('astro').AstroIntegration}
 */
export default () => ({
	name: "dev-toolbar-app",
	hooks: {
		"astro:config:setup": ({ addDevToolbarApp }) => {
			addDevToolbarApp({
				entrypoint: "./astro-dev-toolbar-app/plugin.js",
				id: "my-plugin",
				name: "My Plugin",
			});
		},
	},
});
