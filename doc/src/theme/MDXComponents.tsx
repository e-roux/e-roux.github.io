import React from "react";
// Importing the original mapper + our components according to the Docusaurus doc
import MDXComponents from "@theme-original/MDXComponents";
import { Badge, GhStars, PEPBadge, StarsBadge, WikiBadge } from "@mx/badges";

const Tr: React.FC = ({ children }) => {
  return <tr className="bg-blue-100 h-1.5">{children}</tr>;
};

export default {
  // Reusing the default mapping
  ...MDXComponents,
  Badge,
  StarsBadge,
  PEPBadge,
  GhStars,
  WikiBadge,
  tr: Tr,
};
