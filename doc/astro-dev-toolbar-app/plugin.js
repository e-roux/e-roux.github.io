/**
 * @type {import('astro').DevToolbarApp}
 */
export default {
	id: "my-plugin",
	name: "My Plugin",
	icon: "<svg><rect x='0' y='0' width='100' height='100' /></svg>",
	init() {
		console.log("I'm a dev toolbar app!");
	},
};
