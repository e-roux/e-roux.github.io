import React from "react";
import { useEffect, useRef, useState } from "react";
import Layout from "@theme/Layout";
import { EIA } from "@mx/ui/components/plot/eia";

const CustomPage: React.FC = () => {
  return (
    <Layout title="Custom Page">
      <div>
        <h1>Custom Page</h1>
        <p>This is my custom page.</p>
        <p>We can work with d3.js here.</p>
        <EIA />
      </div>
    </Layout>
  );
};

export default CustomPage;
