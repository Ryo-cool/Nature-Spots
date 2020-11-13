<template>
  <v-card height="150">
    <v-footer
      absolute
      class="font-weight-medium"
      color="green lighten-4"
    >
      <v-col
        class="text-center"
        cols="12"
      >
        {{ new Date().getFullYear() }} — <strong>NatureSpots</strong>
      </v-col>
    </v-footer>
  </v-card>
</template>