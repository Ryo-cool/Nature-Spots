<template>
  <v-card class="mb-4">
    <v-container>
      <v-row>
        <v-col
        cols="12"
        sm="3"
        >
          <div class="headline pt-3">{{spot.name}}</div>
        </v-col>
        <v-col
        cols="5"
        sm="4"
        class="pt-5"
        >
          <v-rating
            v-model="rating"
            background-color="purple lighten-3"
            color="purple"
            readonly
            half-increments
            small
            
          ></v-rating>
          
        </v-col>
        <v-col cols="6" sm="3" class="pt-6">
          <h4>
            {{ rating }}
            (<v-icon>mdi-comment-outline</v-icon>
            {{ reviews.length }}件)
          </h4>
          <!-- <span class="color=myblue">
            ({{ rating }})
          </span> -->
        </v-col>
        
        <v-col
        cols=""
        md="5"
        sm="3"
        class="pt-5"
        >
          <v-btn
            icon
            color="pink"
          >
            <v-icon>
              mdi-heart
            </v-icon>
          </v-btn>
          <v-btn
          icon
          color="myblue"
          >
            <v-icon>
              mdi-export-variant
            </v-icon>
          </v-btn>
        </v-col>
      </v-row>
      <v-divider></v-divider>
      <h3>{{spot.name}}の説明<div class="body-1">{{spot.introduction}}</div></h3>
      <h3>都道府県<div class="body-1">{{prefecture}}</div></h3>
      <h3>住所<div class="body-1">{{spot.address}}</div></h3>
      <h3>ジャンル<div class="body-1">{{location}}</div></h3>
        <GmapMap 
        :center="{lat: spot.latitude, lng: spot.longitude}"
        :zoom="12" 
        ref="map" 
        style="width: 500px; height: 300px"
        >
          <GmapMarker :key="id" v-for="(m,id) in marker_items"
            :position="{lat: spot.latitude, lng: spot.longitude}"
            :title="m.title"
            :clickable="true" :draggable="false" />
        </GmapMap>
    </v-container>
  </v-card>
</template>

<script>
import axios from '~/plugins/axios'

export default {
  data () {
    return {
      spot: {},
      prefecture: {},
      location: {},
      reviews: {},
      rating: 2.6,
      reviews: 300,
      marker_items: [
      {position: {lat: 35.71, lng: 139.72}, title: 'marker_1'},
      ]
    }
  },
  mounted () {
    axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.spot
        this.prefecture = res.data.prefecture.attributes.name
        this.location = res.data.location.attributes.name
        this.reviews = res.data.review
      })
      .catch((error) => {
        console.error(error)
      })
  }
}
</script>