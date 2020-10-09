<template>

  <v-container  class="grey lighten-2">
    <v-breadcrumbs
    divider="-"
    >
    パンくずリスト
    </v-breadcrumbs>
    <v-row>
      <v-col>
        <carousel />
      </v-col>
    </v-row>
    <v-row>
      <v-col
      cols="12"
      md="7"
      >
      <spot-data />
      </v-col>
      <v-col
        cols="12"
        md="5"
      >
        <review-header />
        <reviews />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  layout ({ store }) {
    return store.state.loggedIn ? 'loggedIn' : 'welcome'
  },

  computed: {
  }
  
}
</script>

<style>
h2{
  color:blue
}
</style>