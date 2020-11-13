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
    ></v-autocomplete>
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