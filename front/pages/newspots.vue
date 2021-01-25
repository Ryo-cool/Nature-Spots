<template>
  <v-container>
    <v-row justify="center">
      <v-col cols="12" sm="6" class="my-6 text-center" align-self="center">
        <h1 class="mb-4">スポット投稿</h1>
        <div class="red--text">
          {{ alert }}
        </div>
        <v-text-field
          v-model="name"
          label="スポット名(必須)"
          prepend-icon=""
          type="text"
          outlined
          @change="onChange"
        />

        <!-- <div>緯度{{ lat }}</div>
        <div>{{ locations }}</div>
        <div>{{ address }}</div> -->

        <v-text-field
          v-model="introduction"
          label="説明(必須)"
          prepend-icon=""
          type="text"
          outlined
        />
        <v-img :src="preview" />
        <v-file-input
          chips
          small-chips
          show-size
          label="画像(任意)"
          accept="image/png, image/jpeg, image/bmp"
          prepend-icon="mdi-camera"
          @change="setImage"
        />
        <v-select
          v-model="prefectures"
          label="都道府県(必須)"
          item-text="attributes.name"
          item-value="attributes.id"
          :items="prefecture"
          outlined
        />

        <v-text-field
          v-model="address"
          label="住所(必須)"
          prepend-icon=""
          type="text"
          outlined
        />

        <v-select
          v-model="locations"
          label="ジャンル(必須)"
          item-text="attributes.name"
          item-value="attributes.id"
          :items="location"
          outlined
        />
        <v-btn color="primary" @click="createSpot"> スポットを投稿する </v-btn>
      </v-col>
      <!-- <v-col cols="12" sm="6">
        <v-card class="mx-auto" tile>
          <v-list rounded>
            <v-subheader>SPOTS</v-subheader>
            <v-list-item-group color="primary">
              <v-list-item v-for="spot in spots" :key="spots.id" @click="">
                <v-list-item-content>
                  <nuxt-link
                    :to="$my.spotLinkTo(spot.id)"
                    class="text-decoration-none"
                  >
                    <v-list-item-title v-text="spot.id" />
                    <v-list-item-title v-text="spot.name" />
                  </nuxt-link>
                </v-list-item-content>
              </v-list-item>
            </v-list-item-group>
          </v-list>
        </v-card>
      </v-col> -->
    </v-row>
  </v-container>
</template>

<script>
import axios from "~/plugins/axios"

export default {
  layout({ $auth }) {
    return $auth.loggedIn ? "loggedIn" : "welcome"
  },
  data() {
    return {
      name: "",
      introduction: "",
      prefectures: "",
      address: "",
      locations: "",
      lat: "",
      lng: "",
      alert: "",
      image: null,
      preview: "",
      geocoder: {},
      spots: [],
      prefecture: [],
      location: [],
    }
  },
  mounted() {
    this.$axios.get("/api/v1/spots").then((res) => {
      if (res.data) {
        this.spots = res.data.spots
        this.prefecture = res.data.prefecture
        this.location = res.data.location
      }
    }),
      this.$gmapApiPromiseLazy().then(() => {
        this.geocoder = new google.maps.Geocoder()
      })
  },
  methods: {
    // 入力されたスポット名を住所変換
    onChange() {
      this.geocoder.geocode(
        {
          address: this.name,
        },
        (results, status) => {
          if (status === google.maps.GeocoderStatus.OK) {
            this.alert = ""
            this.lat = results[0].geometry.location.lat()
            this.lng = results[0].geometry.location.lng()
            var ad = results[0].formatted_address.replace("日本、", "")
            this.address = ad
          } else {
            this.alert = "正しいスポットを入力してください"
          }
        }
      )
    },
    setImage(e) {
      this.image = e
      this.preview = URL.createObjectURL(e)
    },
    // スポットをaxiosで登録
    createSpot(e) {
      const formData = new FormData()
      formData.append("photo", this.image)
      formData.append("name", this.name)
      formData.append("introduction", this.introduction)
      formData.append("prefecture_id", this.prefectures)
      formData.append("latitude", this.lat)
      formData.append("longitude", this.lng)
      formData.append("address", this.address)
      formData.append("location_id", this.locations)
      const config = {
        headers: {
          "content-type": "multipart/form-data",
        },
      }
      this.$axios.post("/api/v1/spots", formData, config).then((res) => {
        if (res.data) {
          this.spots.push(res.data)
          this.$router.push("/")
        }
      })
    },
  },
}
</script>

<style></style>
