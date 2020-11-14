<template>
  <v-col
    cols="12"
    md="7"
    class="hidden-ipad-and-up"
  >
    <h1>都道府県から探す</h1>
    <v-card class="mt-4">
      <v-list>
        <v-list-group
          :value="true"
          no-action
          v-model="active"
        >
          <template v-slot:activator>
            <v-list-item-content>
              <v-list-item-title>都道府県一覧</v-list-item-title>
            </v-list-item-content>
          </template>
          
          <v-list-item
            v-for="prefecture in prefectures"
            :key="prefecture.name"
            link
            :to="`prefecture/${prefecture.attributes.id}`"
            v-model="active"
          >
            <v-list-item-title v-text="prefecture.attributes.name"></v-list-item-title>
          </v-list-item>
        </v-list-group>
      </v-list>
    </v-card>
  </v-col>

</template>

<script>

import axios from '~/plugins/axios'

export default {
  data () {
    return {
      prefectures: [],
      active: false,
    }
  },
  mounted() {
    this.$axios.get("api/v1/prefectures")
    .then((res) => {
      this.prefectures = res.data
    })
    .catch((error) => {
      console.error(error)
    })
  }
}
</script>
