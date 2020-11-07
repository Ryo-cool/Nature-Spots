<template>
  <v-breadcrumbs
    :items="items"
  >
    <template v-slot:item="{ item }">
      <v-breadcrumbs-item
        exact
        class="text-truncate"
      >
        <nuxt-link to="/">HOME</nuxt-link> 
        <div style="white-space: pre-wrap">  > </div>
        {{ item.text }}
      </v-breadcrumbs-item>
    </template>
    <template v-slot:divider>
      <v-icon>
        mdi-chevron-right
      </v-icon>
    </template>
  </v-breadcrumbs>
</template>

<script>
export default {
  computed: {
    items () {
      return [
        { text: this.$my.pageTitle(this.$route.name) }
      ]
    }
  }
}
</script>