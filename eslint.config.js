/* eslint-env node */
const { defineConfig } = require('eslint/config');
const expoConfig = require('eslint-config-expo/flat');
const pluginQuery = require('@tanstack/eslint-plugin-query');
const eslintPluginPrettierRecommended = require('eslint-plugin-prettier/recommended');

module.exports = defineConfig([
  expoConfig,
  eslintPluginPrettierRecommended,
  {
    ignores: ['dist/*'],
  },
  {
    rules: {
      'react/display-name': 'off',
      '@tanstack/query/exhaustive-deps': 'error',
    },
    plugins: {
      '@tanstack/query': pluginQuery,
    },
  },
]);
