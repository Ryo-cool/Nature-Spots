<template>
  <div>
    <v-autocomplete
      v-model="value"
      :items="spots"
      item-text="name"
      prepend-inner-icon="mdi-database-search"
      dense
      solo
      height="60"
      hide-no-data
      label="行き先は？"
    >
      <template v-slot:item="data">
        <template>
          
          <v-list-item-content>
            <v-list-item-title>{{ data.item.name }}</v-list-item-title>
          </v-list-item-content>
          <v-list-item-content>
            <v-list-item-title>{{ data.item.id }}</v-list-item-title>
          </v-list-item-content>
        </template>
      </template>
    </v-autocomplete>
  </div>
</template>

<script>

import axios from "~/plugins/axios"

export default {
  data () {
    return {
      spots: [],
      value: null,
      
    }
  },
  created() {
    // ユーザーをaxiosで取得
    this.$axios.get("/api/v1/spots").then(res => {
      if (res.data) {
        this.spots = res.data.spots

      }
    })
  }
}
</script>