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
        
        <nuxt-link
          :to="`spots/${data.item.id}`"
          class="text-decoration-none"
        >
          <template>
            <v-list-item-content>
              <h4>{{ data.item.name }}</h4>
              
            </v-list-item-content>
            
          </template>
          <v-divider></v-divider>
        </nuxt-link>
        
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