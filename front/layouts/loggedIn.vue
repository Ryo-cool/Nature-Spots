<template>
  <v-app>
    <logged-in-app-bar />
    <v-main>
      <nuxt />
    </v-main>
    <logged-in-footer />
  </v-app>
</template>

<script>
export default {
  // middleware: 'authenticator'
}
</script>
