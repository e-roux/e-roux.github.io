import { z, defineCollection } from "astro:content";
import { docsLoader } from "@astrojs/starlight/loaders";
import { docsSchema } from "@astrojs/starlight/schema";

// Define the course item schema
const courseSchema = z.object({
	name: z.string(),
	desc: z.string().optional(),
	link: z.string().url().optional(),
	img: z.string().optional(),
	certificate: z.string().optional(),
	ongoing: z.boolean().optional(),
	"lecture-from": z.string().optional(),
});

// Define the category collection schema
const courseCollection = defineCollection({
	type: "data", // Using 'data' for YAML files
	schema: z.object({
		name: z.string(),
		category: z.string().optional(),
		content: z.array(courseSchema),
	}),
});

const docs = defineCollection({
	loader: docsLoader(),
	schema: docsSchema(),
});

export const collections = {
	docs,
	courses: courseCollection,
};
