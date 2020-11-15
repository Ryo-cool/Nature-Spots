<template>
  <div>
    <v-autocomplete
      v-model="value"
      :items="spots"
      item-text="name"
      prepend-inner-icon="mdi-database-search"
      dense
      solo-inverted
      background-color="green lighten-4"
      color="black"
      height="60"
      hide-no-data
      label="入力し、出たスポットをクリック"
    >
      <template v-slot:item="data">
        <v-list-item :to="`spots/${data.item.id}`" link>
          <v-list-item-icon>
            <v-icon color="green darken-2">mdi-map-marker</v-icon>
          </v-list-item-icon>
          <v-list-item-title v-text="data.item.name"></v-list-item-title>
          
        </v-list-item>
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
<style>
  v-list-item-title{
    width:100px;
  }
</style>