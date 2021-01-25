<template>
  <v-card class="mb-4">
    <v-container>
      <v-row>
        <v-col cols="12" sm="3">
          <div class="headline pt-3">
            {{ spot.name }}
          </div>
          <v-snackbar :value="alert" color="pink" dark timeout="2000">
            お気に入り登録
          </v-snackbar>
          <v-snackbar :value="likeDelete" color="pink" dark timeout="2000">
            お気に入り解除しました
          </v-snackbar>
        </v-col>
        <v-col cols="5" sm="4" class="pt-5">
          <v-rating
            v-model="rating"
            background-color="purple lighten-3"
            color="purple"
            readonly
            half-increments
            small
          />
        </v-col>
        <v-col cols="6" sm="3" class="pt-6">
          <h4>
            {{ rating }}
            <v-icon>mdi-comment-outline</v-icon>()件
          </h4>
          <!-- <span class="color=myblue">
            ({{ rating }})
          </span> -->
        </v-col>

        <v-col cols="" md="5" sm="3" class="pt-5">
          <v-btn
            v-if="favorite"
            icon
            color="pink"
            @click="createFavorite(spot.id)"
          >
            <v-icon> mdi-heart-outline </v-icon>
          </v-btn>
          <v-btn v-else icon color="pink" @click="deleteFavorite(spot.id)">
            <v-icon> mdi-heart </v-icon>
          </v-btn>
          <v-btn icon color="myblue">
            <v-icon> mdi-export-variant </v-icon>
          </v-btn>
        </v-col>
      </v-row>
      <v-divider />
      <h3>
        {{ spot.name }}の説明
        <div class="body-1">
          {{ spot.introduction }}
        </div>
      </h3>
      <h3>
        都道府県
        <div class="body-1">
          {{ prefecture }}
        </div>
      </h3>
      <h3>
        住所
        <div class="body-1">
          {{ spot.address }}
        </div>
      </h3>
      <h3>
        ジャンル
        <div class="body-1">
          {{ location }}
        </div>
      </h3>
      <v-row>
        <v-col>
          <GmapMap
            ref="map"
            :center="{ lat: spot.latitude, lng: spot.longitude }"
            :zoom="12"
            style="width: 100%; height: 300px"
          >
            <GmapMarker
              v-for="(m, id) in marker_items"
              :key="id"
              :position="{ lat: spot.latitude, lng: spot.longitude }"
              :title="m.title"
              :clickable="true"
              :draggable="false"
            />
          </GmapMap>
        </v-col>
      </v-row>
    </v-container>
  </v-card>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  data() {
    return {
      spot: {},
      favUser: {},
      prefecture: {},
      location: {},
      reviews: {},
      photo: "",
      rating: 2.6,
      reviews: 300,
      favorite: true,
      alert: false,
      likeDelete: false,
      marker_items: [
        { position: { lat: 35.71, lng: 139.72 }, title: "marker_1" },
      ],
    }
  },
  created() {
    this.$axios
      .get(`/api/v1/spots/${this.$route.params.id}`)
      .then((res) => {
        this.spot = res.data.spot
        this.prefecture = res.data.prefecture.attributes.name
        this.location = res.data.location.attributes.name
        this.favUser = res.data.favuser
      })
      .catch((error) => {
        console.error(error)
      })
    if (this.favUser === this.$auth.user.id) {
      this.favorite = false
    } else {
      this.favorite = true
    }
  },
  methods: {
    createFavorite(spotId) {
      this.$axios
        .post(`/api/v1/spots/${this.$route.params.id}/favorites`, {
          user_id: this.$auth.user.id,
          spot_id: spotId,
        })
        .then((res) => {
          console.log(res)
          this.alert = true
          this.favorite = false
        })
        .catch((error) => {
          console.log(error)
        })
    },
    deleteFavorite(spotId) {
      this.$axios
        .delete(
          `/api/v1/spots/${this.$route.params.id}/favorites/${this.$auth.user.id}`,
          {
            params: {
              user_id: this.$auth.user.id,
              spot_id: this.spotId,
            },
          }
        )
        .then((res) => {
          console.log(res)
          this.likeDelete = true
          this.favorite = true
        })
        .catch((error) => {
          console.log(error)
        })
    },
  },
}
</script>
