import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import eslintPlugin from "vite-plugin-eslint";

export default defineConfig({
  plugins: [
    elmPlugin({ debug: true }),
    eslintPlugin({
      include: ["index.ts"],
      cache: false,
    }),
  ],
});
