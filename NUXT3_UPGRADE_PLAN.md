# Nuxt 3 Migration Plan

## 1. Environment Setup
- Update Node.js to latest LTS version
- Create a new branch for migration work
- Install Nuxt 3 dependencies

## 2. Package.json Updates
- Replace `nuxt` with `nuxt3`
- Update TypeScript to latest version
- Replace `@nuxtjs/axios` with Nuxt 3's built-in `useFetch`/`$fetch`
- Update Vuetify to v3
- Replace `vuex-module-decorators` with Pinia for state management
- Update ESLint configuration for Vue 3

## 3. Configuration Changes
- Convert `nuxt.config.js` to `nuxt.config.ts` using new Nuxt 3 schema
- Move from Vuex to Pinia for state management
- Update module configuration syntax

## 4. Directory Structure Changes
- Create `server/` directory for API routes (if needed)
- Restructure middleware to match Nuxt 3 conventions
- Ensure proper TypeScript setup with `tsconfig.json` updates

## 5. Component Updates
- Update component syntax for Vue 3 Composition API
- Replace Options API with Composition API where beneficial
- Fix lifecycle methods (`mounted` → `onMounted`, etc.)
- Update template refs syntax
- Replace any deprecated Vue 2 patterns

## 6. Plugin Changes
- Update plugin registration to match Nuxt 3 conventions
- Convert to TypeScript where practical
- Rewrite plugins to use Nuxt 3 composables
- Update auth system to use Nuxt 3 authentication patterns

## 7. CSS/SCSS Updates
- Ensure SCSS setup is properly configured for Nuxt 3
- Update any Vuetify-specific styling 

## 8. Testing
- Thoroughly test all pages and components
- Ensure authentication flows work correctly
- Test API interactions
- Fix any performance issues

## 9. Migration Considerations
- Replace `@nuxtjs/axios` with native `useFetch`/`$fetch` composables
- Rewrite Vuex stores using Pinia
- Update Vue components to Vue 3 syntax
- Update Vuetify components to Vuetify 3
- Replace plugins with Nuxt 3 composables where possible

## 10. Specific Components Needing Attention
- Authentication system (auth.js)
- Google Maps integration (vue2-google-maps → vue3-google-maps)
- Image optimization (needs updated plugin)
- Internationalization (nuxt-i18n → @nuxtjs/i18n for Nuxt 3)
- Service worker implementation