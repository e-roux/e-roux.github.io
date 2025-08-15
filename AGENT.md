# AGENT.md

## Overview

The `@mx/badges` package provides reusable and customizable badge components for Web Components, Astro, and React. These badges integrate seamlessly into various web applications and dynamically generate badge visuals using Shields.io.

## Features

### Web Components
- Custom HTML elements like `<badge-component>`.
- Attributes:
  - `alt`: Accessibility text (default: "Documentation").
  - `color`: Badge color (default: "brightgreen").
  - `href`: Link URL (default: "img/default.png").
  - `label`: Badge label (default: "docs").
  - `logo`: Badge logo (default: "Read-the-docs").
  - `message`: Badge message (default: "stable").

### Astro Components
- **`PepBadge.astro`**: Badge for Python Enhancement Proposals.
  ```astro
  <PepBadge nr="8" />
  ```
- **`StarsBadge.astro`**: GitHub stars badge.
  ```astro
  <StarsBadge repo="octocat/Hello-World" />
  ```

### React Components
- **`Badge`**: Base badge component.
- **`StarsBadge`**: GitHub stars badge.
- **`PEPBadge`**: Python Enhancement Proposal badge.
- **`WikiBadge`**: Experimental Wikipedia badge.

#### Example
```tsx
import { StarsBadge, PEPBadge, WikiBadge } from "@mx/badges/src/react";

<StarsBadge repo="octocat/Hello-World" />
<PEPBadge nr="8" />
<WikiBadge />
```

## Implementation Details

### Web Components
- Encapsulated in Shadow DOM for reusability.
- Dynamically generates badges using Shields.io.

### Astro Components
- Use framework-specific props for customization.
- Generate Shields.io URLs dynamically.

### React Components
- Extend the base `Badge` component.
- Utilize props for dynamic customization.

## Testing Instructions

### Web Components
1. **Tools**: Use Jest with jsdom for unit testing.
2. **Tests**:
   - Render the custom element and verify DOM structure.
   - Test attribute handling (e.g., `alt`, `color`, `href`).
   - Check Shadow DOM encapsulation.

### Astro Components
1. **Tools**: Use Playwright or Cypress for integration and end-to-end testing.
2. **Tests**:
   - Render components with props in an Astro environment.
   - Verify generated badge visuals and links.

### React Components
1. **Tools**: Use Jest with React Testing Library.
2. **Tests**:
   - Test component rendering and prop behavior.
   - Simulate user interactions and validate outcomes.

## Future Enhancements

- Support for more badge types.
- Add animations or interactivity.
- Explore alternative badge generation services.

